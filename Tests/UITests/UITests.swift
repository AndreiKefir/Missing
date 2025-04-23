//
//  UITests.swift
//  UITests
//
//  Created by Andy Kefir on 23/04/2025.
//

import XCTest

final class UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }

    func testLoadAndDisplayPeople() throws {
        let table = app.tables[AccessibilityIdentifier.mainTable.rawValue]
        XCTAssertTrue(table.waitForExistence(timeout: 5), "MainTable didn't appear")
        
        let firstCell = table.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "First cell didn't appear")
        XCTAssertTrue(firstCell.images.element.exists)
        XCTAssertTrue(firstCell.staticTexts.element.exists)
    }
    
    func testSearchFilterFlow() throws {
        // open Search screen
        let openSearchButton = app.navigationBars.buttons[AccessibilityIdentifier.openSearchButton.rawValue]
        XCTAssertTrue(openSearchButton.exists, "Search button must exist on main screen")
        openSearchButton.tap()
        XCTAssertTrue(app.navigationBars["Search"].waitForExistence(timeout: 2))
        
        // set fields
        let forename = app.textFields[AccessibilityIdentifier.forenameTextField.rawValue]
        let minAge = app.textFields[AccessibilityIdentifier.minAgeTextField.rawValue]
        let maxAge = app.textFields[AccessibilityIdentifier.maxAgeTextField.rawValue]
        let genderControl = app.segmentedControls[AccessibilityIdentifier.genderSegmentControl.rawValue]
        
        forename.tap()
        forename.typeText("John")
        minAge.tap()
        minAge.typeText("20")
        maxAge.tap()
        maxAge.typeText("50")
        genderControl.buttons.element(boundBy: 1).tap()
        
        // do search
        let searchButton = app.buttons[AccessibilityIdentifier.searchButton.rawValue]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        XCTAssertTrue(app.navigationBars["Missing People"].waitForExistence(timeout: 2))
        
        // check right people in table
        let table = app.tables[AccessibilityIdentifier.mainTable.rawValue]
        XCTAssertTrue(table.cells.count > 0)
        for i in 0..<table.cells.count {
            let cell = table.cells.element(boundBy: i)
            let info = cell.staticTexts.element(boundBy: 1).label
            XCTAssertTrue(info.contains("years old"))
        }
    }
    
}
