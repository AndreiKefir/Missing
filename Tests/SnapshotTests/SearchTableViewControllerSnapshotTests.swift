//
//  SnapshotTests.swift
//  SnapshotTests
//
//  Created by Andy Kefir on 24/04/2025.
//

import XCTest
import SnapshotTesting

@testable import Missing

final class SearchTableViewControllerSnapshotTests: XCTestCase {
    var vc: SearchTableViewController!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SearchTableViewController.self))
        vc = storyboard.instantiateViewController(withIdentifier: "searchVC") as? SearchTableViewController
        vc.loadViewIfNeeded()
        
        UIView.setAnimationsEnabled(false)
    }
    
    override func tearDownWithError() throws {
        vc = nil
    }
    
    func testInitialState_light() {
        assertSnapshot(of: vc, as: .image(on: .iPhone13), named: "Initial_light" )
    }
    
    func testInitialState_dark() {
        vc.overrideUserInterfaceStyle = .dark
        vc.loadViewIfNeeded()
        vc.view.layoutIfNeeded()
        
        assertSnapshot(of: vc, as: .image(on: .iPhone13), named: "Initial_dark")
    }

    func testFilledInputs_light() {
        vc.forename.text = "John"
        vc.familyName.text = "Doe"
        vc.genderSegmentControl.selectedSegmentIndex = 1
        vc.minAge.text = "20"
        vc.maxAge.text = "50"
        vc.nationalityLabel.text = "Albania"
        
        vc.loadViewIfNeeded()
        vc.view.layoutIfNeeded()
        
        assertSnapshot(of: vc, as: .image(on: .iPhone13), named: "Filled_light")
    }
    
    func testFilledInputs_dark() {
        vc.overrideUserInterfaceStyle = .dark
        vc.forename.text = "John"
        vc.familyName.text = "Doe"
        vc.genderSegmentControl.selectedSegmentIndex = 1
        vc.minAge.text = "20"
        vc.maxAge.text = "50"
        vc.nationalityLabel.text = "Albania"
        
        vc.loadViewIfNeeded()
        vc.view.layoutIfNeeded()
        
        assertSnapshot(of: vc, as: .image(on: .iPhone13), named: "Filled_dark")
    }
}
