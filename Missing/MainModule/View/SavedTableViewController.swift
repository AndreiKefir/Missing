//
//  SavedTableViewController.swift
//  Missing
//
//  Created by Andy Kefir on 12/04/2025.
//

import UIKit
import Combine

class SavedTableViewController: UITableViewController {
    private let viewModel: MainViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved persons"
        
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.reuseIdentifier)
        
        viewModel.$savedPersons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.loadSavedPersons()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Saved: \(viewModel.savedPersons.count) persons"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.savedPersons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = viewModel.savedPersons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as? PersonCell
            
            let image: UIImage? = {
                if let data = viewModel.savedPersons[indexPath.row].photo {
                    return UIImage(data: data)
                }
                return nil
            }()
            
        cell?.configure(id: person.personID, name: person.familyName,
                           forename: person.forename,
                           nationality: person.nationality,
                           dateOfBirth: person.dateOfBirth,
                           image: image)
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = viewModel.savedPersons[indexPath.row]
        let detailVC = DetailTableViewController()
        detailVC.personID = person.personID.replacingOccurrences(of: "/", with: "-")
        print(detailVC.personID!)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let person = viewModel.savedPersons[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            viewModel.savedPersons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            CoreDataManager.shared.deletePerson(by: person.personID)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
