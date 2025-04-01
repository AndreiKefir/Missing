//
//  DetailTableViewController.swift
//  Missing
//
//  Created by Andy Kefir on 03/04/2025.
//

import UIKit
import Combine

class DetailTableViewController: UITableViewController {
    var personID: String!
    
    private var viewModel: DetailViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailViewModel(personID: personID)

        title = "Person Info"
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.reuseIdentifier)
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        //Bind updates to reload table data
        Publishers.CombineLatest(viewModel.$personData, viewModel.$personImagesData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.loadPersonDetails()
        viewModel.loadPersonImages()
    }

    // MARK: - Tableview

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.personData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.personImagesData.isEmpty ? 0 : 1
        }
        return viewModel.personData[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "Identity particulars"
        case 2: return viewModel.personData[2].count > 0 ? "Physical description" : nil
        case 3: return viewModel.personData[3].count > 0 ?  "Details" : nil
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel.personImagesData)
            cell.imageTapHandler = { [weak self] tappedImage in
                self?.presentPhotoPopover(with: tappedImage, from: cell)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseIdentifier, for: indexPath) as? DetailCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel.personData[indexPath.section][indexPath.row])
            return cell
        }
    }
    
    private func presentPhotoPopover(with image: UIImage, from cell: UITableViewCell) {
        let photoVC = PhotoViewController()
        photoVC.image = image
        
        let navVC = UINavigationController(rootViewController: photoVC)
        navVC.modalPresentationStyle = .popover
        
        present(navVC, animated: true)
    }
}
