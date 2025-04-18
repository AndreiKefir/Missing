//
//  MainViewModel.swift
//  Missing
//
//  Created by Andy Kefir on 01/04/2025.
//

import Foundation
import Combine

//@MainActor
final class MainViewModel: ObservableObject {
    @Published private(set) var persons: [Notice] = []
    @Published private(set) var imagesData: [String: Data?] = [:]
    @Published private(set) var message: String?
    @Published var savedPersons: [Person] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let dataManager: CoreDataManagerProtocol
    private let network: NetworkProtocol
    let countries = Countries()
    var searchQuery: [URLQueryItem] = []
    private var nextUrlString: String?
    private var isLoading = false
    
    init(dataManager: CoreDataManagerProtocol = CoreDataManager.shared, network: NetworkProtocol = Network.shared) {
        self.dataManager = dataManager
        self.network = network
    }
    
    func loadPersons() {
        guard !isLoading else { return }
        isLoading = true
        
        guard let url = try? network.createURL(by: searchQuery) else {
            message = "Invalid URL."
            isLoading = false
            return
        }
        
        network.fetchPersons(from: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.message = "Error loading: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.persons = result.embedded.notices
                self.nextUrlString = result.links.next?.href
                self.message = "Search result: \(result.total) persons"
                self.loadImages(for: result.embedded.notices)
            })
            .store(in: &cancellables)
    }
    
    func loadMorePersons() {
        guard !isLoading, let nextUrlString = nextUrlString, let url = URL(string: nextUrlString) else { return }
        isLoading = true
        
        network.fetchPersons(from: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.persons.append(contentsOf: result.embedded.notices)
                self.nextUrlString = result.links.next?.href
                self.loadImages(for: result.embedded.notices)
            })
            .store(in: &cancellables)
    }
    
    func loadImages(for persons: [Notice]) {
        persons.forEach { person in
            guard let link = person.links.thumbnail?.href else { return }
            network.fetchImageData(from: link)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Image dowloaded failed: \(error)")
                    }
                },
                      receiveValue: { [weak self] data in
                    self?.imagesData[person.entityID] = data
                })
                .store(in: &cancellables)
        }
    }
    
    func savePerson(from notice: Notice) {
        if dataManager.fetchPerson(by: notice.entityID) != nil {
            print("Person already saved.")
            return
        }
        let person = dataManager.createPerson()
        person.personID = notice.entityID
        person.familyName = notice.name
        person.forename = notice.forename
        person.dateOfBirth = notice.dateOfBirth
        person.nationality = countries.getCountryName(by: notice.nationalities?.first ?? "")
        person.photo = imagesData[notice.entityID] ?? nil
        dataManager.saveContext()
    }
    
    func loadSavedPersons() {
        savedPersons = dataManager.fetchAllPersons()
    }
    
    func person(at index: Int) -> Notice? {
        guard index >= 0 && index < persons.count else { return nil }
        return persons[index]
    }
    
    func imagedataForPerson(with personID: String) -> Data? {
        guard let data = imagesData[personID] else { return nil }
        return data
    }
    
    func updateImagesData(for personID: String, data: Data) {
        imagesData[personID] = data
    }
    
    func calculateAge(from birthDate: String?) -> String {
        guard let birthDate = birthDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let date = formatter.date(from: birthDate) else { return "" }
        let years = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
        return "\(years) years old"
    }
}
