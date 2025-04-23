//
//  DetailViewModelTests.swift
//  DetailViewModelTests
//
//  Created by Andy Kefir on 21/04/2025.
//

import XCTest
import Combine

@testable import Missing

final class DetailViewModelTests: XCTestCase {
    var sut: DetailViewModel!
    var mockNetwork: MockNetwork!
    var cancellables: Set<AnyCancellable>!
    

    override func setUpWithError() throws {
        mockNetwork = MockNetwork()
        sut = DetailViewModel(personID: "1234-1234", network: mockNetwork)
        cancellables = []
    }

    override func tearDownWithError() throws {
        sut = nil
        mockNetwork = nil
        cancellables = nil
    }

    func testLoadpersonDetails_ShouldPopulatePersonData() throws {
        let personDetails = PersonDetails(country: "UK", dateOfBirth: "1990/01/01", motherName: "Jolie", countriesLikelyToBeVisited: ["US"], motherForename: "Jolie", nationalities: ["US"], eyesColorsID: ["BRO"], sexID: "M", forename: "John", countryOfBirthID: "UK", issuingCountry: "UK", hairsID: ["BRO"], place: "Somewhere", languagesSpokenIDS: ["UK"], dateOfEvent: "2000/01/01", height: 1.88, fatherForename: "Jack", distinguishingMarks: "someMarks", birthName: "John", weight: 0.60, entityID: "1234-1234", placeOfBirth: "somewhere", fatherName: "Jack", name: "Doe", links: Links(images: downloadLink(href: "https://example.com/1234-1234/images")))
        mockNetwork.mockPersonDetails = personDetails
        
        let expectation = XCTestExpectation(description: "Person details loaded")
        
        sut.$personData
            .dropFirst()
            .sink { data in
                if !data[1].isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadPersonDetails()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(sut.personData[1].contains { $0.1 == "Doe"})
    }
    
    func testLoadpersonImages_ShouldPopulateImagesData() throws {
        let image = PersonImage(imageLinks: ImageLink(linksSelf: PhotoLink(href: "https://example.com/image.jpg")))
        let imagesLink = PersonImageslink(embedded: EmbeddedPhotos(images: [image]))
        mockNetwork.mockPersonImagesLink = imagesLink
        mockNetwork.mockImageData = Data([0xFF])
        
        let expectation = XCTestExpectation(description: "Images loaded")
        
        sut.$personImagesData
            .dropFirst()
            .sink { data in
                if !data.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadPersonImages()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(sut.personImagesData.first, Data([0xFF]))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
