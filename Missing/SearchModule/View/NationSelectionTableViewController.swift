//
//  NationTableViewController.swift
//  Missing
//
//  Created by Andy Kefir on 07/04/2025.
//

import UIKit

class NationSelectionTableViewController: UITableViewController, UISearchResultsUpdating {
    weak var delegate: NationSelectDelegate?
    
    var viewModel = SearchViewModel()
    var filteredCountries: [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Country"
        
        filteredCountries = viewModel.filterCountries(with: "")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Country"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "countryCell")

    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredCountries = viewModel.filterCountries(with: searchText)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = filteredCountries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = filteredCountries[indexPath.row]
        delegate?.didSelectNation(selectedCountry)
        navigationController?.popViewController(animated: true)
    }
}
