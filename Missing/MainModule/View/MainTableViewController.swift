//
//  MainTableViewController.swift
//  Missing
//
//  Created by Andy Kefir on 02/04/2025.
//

import UIKit
import Combine

final class MainTableViewController: UITableViewController, SearchFilterDelegate, UITableViewDataSourcePrefetching {
    
    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = MainViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadPersons()
    }

    private func setupUI() {
        title = "Missing People"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearchVC))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openSavedPersons))
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.reuseIdentifier)
        tableView.prefetchDataSource = self
    }

    private func bindViewModel() {
        viewModel.$persons
            .combineLatest(viewModel.$imagesData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _ in self?.tableView.reloadData() }
            .store(in: &cancellables)
    }

    @objc private func openSearchVC() {
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "searchVC") as? SearchTableViewController else { return }
        searchVC.delegate = self
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @objc private func openSavedPersons() {
        let savedVC = SavedTableViewController(viewModel: viewModel)
        navigationController?.pushViewController(savedVC, animated: true)
    }

    func didUpdateSearchQuery(_ queryItems: [URLQueryItem]) {
        viewModel.searchQuery = queryItems
        viewModel.loadPersons()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.message != nil ? viewModel.message : "Searching..."
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.persons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as? PersonCell,
              indexPath.row < viewModel.persons.count else { return UITableViewCell() }

        let person = viewModel.persons[indexPath.row]
        let image = viewModel.imagesData[person.entityID] ?? nil
        cell.configure(
            id: person.entityID,
            name: person.name,
            forename: person.forename,
            nationality: viewModel.countries.getCountryName(by: person.nationalities?.first ?? ""),
            dateOfBirth: viewModel.calculateAge(from: person.dateOfBirth),
            image: image.flatMap { UIImage(data: $0) }
        )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = viewModel.persons[indexPath.row]
        let detailVC = DetailTableViewController()
        detailVC.personID = person.entityID.replacingOccurrences(of: "/", with: "-")
        print(detailVC.personID!)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let notice = viewModel.persons[indexPath.row]
        let saveAction = UIContextualAction(style: .normal, title: "Save") { [weak self] _, _, completion in
            self?.viewModel.savePerson(from: notice)
            completion(true)
        }
        saveAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [saveAction])
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height * 1.5 {
            viewModel.loadMorePersons()
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            for indexPath in indexPaths {
                guard let person = viewModel.person(at: indexPath.row) else { continue }
                if viewModel.imagedataForPerson(with: person.entityID) != nil { continue }
                guard let imageLink = person.links.thumbnail?.href else { continue }

                Network.shared.fetchImageData(from: imageLink)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] data in
                        guard let self = self else { return }
                        self.viewModel.updateImagesData(for: person.entityID, data: data)
                        //if cell is still visible -> update image for this cell
                        if let cell = tableView.cellForRow(at: indexPath) as? PersonCell,
                           let image = UIImage(data: data) {
                            cell.updateImage(image)
                        }
                    })
                    .store(in: &cancellables)
            }
        }
}
