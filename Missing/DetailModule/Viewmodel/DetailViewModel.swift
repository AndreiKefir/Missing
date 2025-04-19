
import Foundation
import Combine

class DetailViewModel {
    @Published private(set) var personImagesData: [Data] = []
    @Published private(set) var personData: [[(String?, String?)]] = [[], [], [], []]
    
    private var cancellables = Set<AnyCancellable>()
    private let network: NetworkProtocol
    let personID: String
    private let countries = Countries()
    
    init(personID: String, network: NetworkProtocol = Network.shared) {
        self.personID = personID
        self.network = network
    }
    
    func loadPersonDetails() {
        network.fetchPersonDetails(for: personID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error load person details: \(error)")
                case .finished: break
                }
            }, receiveValue: { [weak self] personDetails in
                self?.createPersonData(from: personDetails)
            })
            .store(in: &cancellables)
    }
    
    func loadPersonImages() {
        network.fetchPersonImagesLink(for: personID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { imagesLink in
                self.loadImageData(from: imagesLink.embedded.images)
            })
            .store(in: &cancellables)
    }
    
    func loadImageData(from personImages: [PersonImage]) {
        for image in personImages {
            network.fetchImageData(from: image.imageLinks.linksSelf.href)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        print("No image data: \(error)")
                    }
                }, receiveValue: { [weak self] imageData in
                    self?.personImagesData.append(imageData)

                })
                .store(in: &cancellables)
        }
    }
    
    func createPersonData(from person: PersonDetails) {
        personData[1].append(("Family name", person.name ?? ""))
        personData[1].append(("Forename", person.forename ?? ""))
        if let gender = person.sexID {
            let genderString = (gender == "M") ? "Male" : "Female"
            personData[1].append(("Gender", genderString))
        }
        personData[1].append(("Date of birth", person.dateOfBirth ?? ""))
        if let placeOfBirth = person.placeOfBirth {
            personData[1].append(("Place of birth", placeOfBirth))
        }
        if let nations = person.nationalities {
            let nationsArray = nations.map { countries.getCountryName(by: $0) }
            personData[1].append(("Nationality", nationsArray.joined(separator: ", ")))
        }
        if let place = person.place {
            personData[1].append(("Place of disappearance", place))
        }
        if let dateOfEvent = person.dateOfEvent {
            personData[1].append(("Date of disappearance", dateOfEvent))
        }
        if let countriesLikely = person.countriesLikelyToBeVisited {
            let countriesArray = countriesLikely.map { countries.getCountryName(by: $0 ?? "")}
            personData[1].append(("Countries likely visited", countriesArray.joined(separator: ", ")))
        }
        if let issuingCountry = person.issuingCountry {
            personData[1].append(("Issuing country", countries.getCountryName(by: issuingCountry)))
        }
        if let distinguishingMarks = person.distinguishingMarks {
            personData[1].append(("Distinguishing marks", distinguishingMarks))
        }
        if let height = person.height {
            personData[2].append(("Height", "\(height) metres"))
        }
        if let weight = person.weight {
            personData[2].append(("Weight", "\(weight) kilograms"))
        }
        if let hairColors = person.hairsID {
            personData[2].append(("Colour of hair", hairColors.joined(separator: ", ")))
        }
        if let eyesColors = person.eyesColorsID {
            personData[2].append(("Colour of eyes", eyesColors.joined(separator: ", ")))
        }
        if let fatherName = person.fatherName {
            personData[3].append(("Father's family name", fatherName))
        }
        if let fatherForename = person.fatherForename {
            personData[3].append(("Father's forename", fatherForename))
        }
        if let motherName = person.motherName {
            personData[3].append(("Mother's family name", motherName))
        }
        if let motherForename = person.motherForename {
            personData[3].append(("Mother's forename", motherForename))
        }
        if let languages = person.languagesSpokenIDS {
            personData[3].append(("Language(s) spoken", languages.joined(separator: ", ")))
        }
    }
    
}
