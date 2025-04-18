//
//  Tests.swift
//  Tests
//
//  Created by Andy Kefir on 16/04/2025.
//

import XCTest
import Combine

@testable import Missing

final class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockNetwork: MockNetwork!
    var mockDataManager: MockCoreDataManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockNetwork = MockNetwork()
        mockDataManager = MockCoreDataManager()
        viewModel = MainViewModel(dataManager: mockDataManager, network: mockNetwork)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetwork = nil
        mockDataManager = nil
        cancellables = nil
    }
    
    func testLoadPersons_success() throws {
        let expectation = XCTestExpectation(description: "Persons loaded")
        
        mockNetwork.mockPersons = Notices(total: 1,
                                          embedded: Embedded(notices: [Notice(dateOfBirth: "1990/01/01", nationalities: ["US"], name: "Doe", forename: "John", entityID: "1234/1234", links: NoticeLinks(linkSelf: nil, images: nil, thumbnail: nil))]),
                                          links: PeopleLinks(next: nil)
        )
        
        viewModel.$persons
            .dropFirst()
            .sink { persons in
                XCTAssertEqual(persons.count, 1)
                XCTAssertEqual(persons.first?.name, "Doe")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadPersons()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadPersons_failure() throws {
        let expectation = XCTestExpectation(description: "Error message published")
        mockNetwork.shouldFail = true
        
        viewModel.$message
            .dropFirst()
            .sink { message in
                XCTAssertNotNil(message)
                XCTAssertTrue(message!.contains("Error loading"))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadPersons()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadImages_downloadsAndStoresImagesData() throws {
        let mockDataManager = MockCoreDataManager()
        let mockNetwork = MockNetwork()
        let viewModel = MainViewModel(dataManager: mockDataManager, network: mockNetwork)
        
        let notice = Notice(dateOfBirth: "2000/01/01", nationalities: ["US"], name: "Doe", forename: "John", entityID: "1234/1234", links: NoticeLinks(linkSelf: nil, images: nil, thumbnail: Link(href: "https://mock.com/image")))
        
        let expectedData = "mockData".data(using: .utf8)!
        mockNetwork.mockImageData = expectedData
        
        viewModel.loadImages(for: [notice])
        
        let expectation = XCTestExpectation(description: "Image data loaded")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.imagesData[notice.entityID], expectedData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCalculateAge_withValidDate() throws {
        let birthDateString = "2000/01/01"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let birthDate = formatter.date(from: birthDateString) else {
            XCTFail("Failed to parse date string")
            return
        }
        let referenceDate = Date()
        let expectedAge = Calendar.current.dateComponents([.year], from: birthDate, to: referenceDate).year ?? 0

        let result = viewModel.calculateAge(from: birthDateString)

        XCTAssertEqual(result, "\(expectedAge) years old")
    }
    
    func testCalculateAge_withInvalidDate() throws {
        XCTAssertEqual(viewModel.calculateAge(from: "wrong format"), "")
        XCTAssertEqual(viewModel.calculateAge(from: nil), "")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
