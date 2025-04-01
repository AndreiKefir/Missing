//
//  SearchTableViewController.swift
//  Missing
//
//  Created by Andy Kefir on 07/04/2025.
//

import UIKit

class SearchTableViewController: UITableViewController, NationSelectDelegate, UITextFieldDelegate {
    private var viewModel = SearchViewModel()
    weak var delegate: SearchFilterDelegate?
    
    @IBOutlet weak var forename: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var minAge: UITextField!
    @IBOutlet weak var maxAge: UITextField!
    @IBOutlet weak var nationalityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        forename.delegate = self
        familyName.delegate = self
        minAge.delegate = self
        maxAge.delegate = self
        
        addDoneButtonOnKeyboard(textField: minAge)
        addDoneButtonOnKeyboard(textField: maxAge)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendProperties()
        let queryItems = viewModel.createSearchQuery()
        delegate?.didUpdateSearchQuery(queryItems)
    }
    
    
    @IBAction func correctTextfield(_ sender: UITextField) {
        guard let text = sender.text, let value = Int(text), (0...120).contains(value) else {
            sender.text = ""
            return
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace, doneButton]
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
    
    func sendProperties() {
        viewModel.forename = forename.text
        viewModel.familyName = familyName.text
        viewModel.genderIndex = genderSegmentControl.selectedSegmentIndex
        viewModel.minAge = Int(minAge.text ?? "0") ?? nil
        viewModel.maxAge = Int(maxAge.text ?? "0") ?? nil
        viewModel.nationality = nationalityLabel.text ?? "All"
    }
    
    func didSelectNation(_ nation: String) {
        viewModel.nationality = nation
        nationalityLabel.text = nation
    }
}
