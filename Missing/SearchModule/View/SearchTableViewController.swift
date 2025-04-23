//
//  SearchTableViewController.swift
//  Missing
//
//  Created by Andy Kefir on 07/04/2025.
//

import UIKit
import Combine

class SearchTableViewController: UITableViewController, NationSelectDelegate, UITextFieldDelegate {
    private var viewModel = SearchViewModel()
    weak var delegate: SearchFilterDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var forename: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var minAge: UITextField!
    @IBOutlet weak var maxAge: UITextField!
    @IBOutlet weak var nationalityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        setupBindings()
        
        forename.delegate = self
        familyName.delegate = self
        minAge.delegate = self
        maxAge.delegate = self
        
        addDoneButtonOnKeyboard(textField: minAge, infoText: "possible range from 1 to 119")
        addDoneButtonOnKeyboard(textField: maxAge, infoText: "possible range from 1 to 119")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.genderIndex = genderSegmentControl.selectedSegmentIndex
        let queryItems = viewModel.createSearchQuery()
        delegate?.didUpdateSearchQuery(queryItems)
    }
    
    private func setupBindings() {
        forename.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        familyName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        minAge.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        maxAge.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        viewModel.$nationality
            .sink { [weak self] nationality in
                self?.nationalityLabel.text = nationality
            }
            .store(in: &cancellables)
        
        viewModel.$genderIndex
            .sink { [weak self] genderIndex in
                self?.genderSegmentControl.selectedSegmentIndex = genderIndex
            }
            .store(in: &cancellables)
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        switch sender {
        case forename: viewModel.forename = sender.text ?? nil
        case familyName: viewModel.familyName = sender.text ?? nil
        case minAge: viewModel.minAge = Int(sender.text ?? "")
        case maxAge: viewModel.maxAge = Int(sender.text ?? "")
        default : break
        }
    }
    
    @IBAction func correctTextfield(_ sender: UITextField) {
        guard let text = sender.text, let value = Int(text), (1...119).contains(value) else {
            sender.text = ""
            return
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField, infoText: String) {
        let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        
        let label = UILabel()
        label.text = infoText
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 13)
        
        let labelItem = UIBarButtonItem(customView: label)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [labelItem, flexSpace, doneButton]
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NationSelectionTableViewController()
        if indexPath.section == 4 {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didSelectNation(_ nation: String) {
        viewModel.nationality = nation
        nationalityLabel.text = nation
    }
}
