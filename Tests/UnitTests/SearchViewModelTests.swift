//
//  SearchViewModelTests.swift
//  SearchViewModelTests
//
//  Created by Andy Kefir on 22/04/2025.
//

import XCTest

@testable import Missing

final class SearchViewModelTests: XCTestCase {
    var sut: SearchViewModel!
    

    override func setUpWithError() throws {
        sut = SearchViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCreateSearchQuery_invalidAges_emptyURLQueryItem() throws {
        sut.minAge = 0
        sut.maxAge = 120
        let items = sut.createSearchQuery()
        XCTAssertFalse(items.contains { $0.name == "ageMin" })
        XCTAssertFalse(items.contains { $0.name == "ageMax" })
        XCTAssertTrue(items.isEmpty)
    }
    
    func testCreateSearchQuery_allFieldsSet_correctURLQueryItems() throws {
        sut.forename = "John"
        sut.familyName = "Doe"
        sut.genderIndex = 1      //Male
        sut.minAge = 5
        sut.maxAge = 30
        sut.nationality = "Albania"    //"AL"
        
        let items = sut.createSearchQuery()
        
        XCTAssertEqual(items.count, 6)
        XCTAssertEqual(items[0], URLQueryItem(name: "forename", value: "John"))
        XCTAssertEqual(items[1], URLQueryItem(name: "name", value: "Doe"))
        XCTAssertEqual(items[2], URLQueryItem(name: "sexId", value: "M"))
        XCTAssertEqual(items[3], URLQueryItem(name: "ageMin", value: "5"))
        XCTAssertEqual(items[4], URLQueryItem(name: "ageMax", value: "30"))
        XCTAssertEqual(items[5], URLQueryItem(name: "nationality", value: "AL"))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
