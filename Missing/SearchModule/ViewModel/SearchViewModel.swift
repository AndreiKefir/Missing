//
//  SearchViewModel.swift
//  Missing
//
//  Created by Andy Kefir on 07/04/2025.
//

import Foundation

class SearchViewModel {
    private let countries: Countries
    
    @Published var forename: String?
    @Published var familyName: String?
    @Published var genderIndex: Int = 0   // 0: All, 1: Male, 2: Female
    @Published var minAge: Int?
    @Published var maxAge: Int?
    @Published var nationality: String = "All"
        
    init(countries: Countries = Countries()) {
        self.countries = countries
    }
    
    func filterCountries(with searchText: String) -> [String] {
        let allCountries = countries.countriesList.map { $0.0 }
        return searchText.isEmpty ? allCountries : allCountries.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    func createSearchQuery() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        if let foreName = forename, !foreName.isEmpty {
            queryItems.append(URLQueryItem(name: "forename", value: foreName))
        }
        if let familyName = familyName, !familyName.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: familyName))
        }
        if genderIndex == 1 {
            queryItems.append(URLQueryItem(name: "sexId", value: "M"))
        } else if genderIndex == 2 {
            queryItems.append(URLQueryItem(name: "sexId", value: "F"))
        }
        if let minAge = minAge, minAge > 0 && minAge < 120 {
            queryItems.append(URLQueryItem(name: "ageMin", value: String(minAge)))
        }
        if let maxAge = maxAge, maxAge > 0 && maxAge < 120 {
            queryItems.append(URLQueryItem(name: "ageMax", value: String(maxAge)))
        }
        if nationality != "All" {
            let code = countries.getCountryCode(by: nationality)
            queryItems.append(URLQueryItem(name: "nationality", value: code))
        }
        return queryItems
    }
}
