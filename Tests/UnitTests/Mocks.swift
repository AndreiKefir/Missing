//
//  Mocks.swift
//  Tests
//
//  Created by Andy Kefir on 18/04/2025.
//

import Foundation
import Combine
@testable import Missing

class MockNetwork: NetworkProtocol {
    var shouldFail = false
    var mockPersons: Notices = Notices(total: 0, embedded: Embedded(notices: []), links: PeopleLinks(next: nil))
    var mockImageData: Data!
    var mockPersonDetails: PersonDetails!
    var mockPersonImagesLink: PersonImageslink!
    
    func createURL(by queries: [URLQueryItem]) throws -> URL {
        return URL(string: "https://example.com")!
    }
    
    func fetchPersons(from url: URL) -> AnyPublisher<Notices, Error> {
        if shouldFail {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        } else {
            return Just(mockPersons)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchImageData(from urlString: String) -> AnyPublisher<Data, Error> {
        if shouldFail {
            return Fail(error: URLError(.cannotLoadFromNetwork)).eraseToAnyPublisher()
        } else {
            return Just(mockImageData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchPersonDetails(for id: String) -> AnyPublisher<PersonDetails, Error> {
        Just(mockPersonDetails)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPersonImagesLink(for id: String) -> AnyPublisher<PersonImageslink, any Error> {
        Just(mockPersonImagesLink)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


class MockCoreDataManager: CoreDataManagerProtocol {
    var savedPersons: [Person] = []
    
    func createPerson() -> Person {
        let person = Person()
        savedPersons.append(person)
        return person
    }
    
    func fetchPerson(by id: String) -> Person? {
        return savedPersons.first(where: { $0.personID == id })
    }
    
    func fetchAllPersons() -> [Person] {
        return savedPersons
    }
    
    func saveContext() {
        print("Context saved successfully.")
    }
    
    func deletePerson(by id: String) {
        print("Person deleted successfully.")
    }
}
