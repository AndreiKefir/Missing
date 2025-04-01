//
//  PersonInfo.swift
//  Missing
//
//  Created by Andy Kefir on 03/04/2025.
//

import Foundation

struct PersonDetails: Codable {
    let country, dateOfBirth, motherName: String?
    let countriesLikelyToBeVisited: [String?]?
    let motherForename: String?
    let nationalities, eyesColorsID: [String]?
    let sexID, forename, countryOfBirthID, issuingCountry: String?
    let hairsID: [String]?
    let place: String?
    let languagesSpokenIDS: [String]?
    let dateOfEvent: String?
    let height: Double?
    let fatherForename: String?
    let distinguishingMarks: String?
    let birthName: String?
    let weight: Double?
    let entityID: String
    let placeOfBirth, fatherName: String?
    let name: String?
    let links: Links

    enum CodingKeys: String, CodingKey {
        case country
        case dateOfBirth = "date_of_birth"
        case motherName = "mother_name"
        case countriesLikelyToBeVisited = "countries_likely_to_be_visited"
        case motherForename = "mother_forename"
        case nationalities
        case eyesColorsID = "eyes_colors_id"
        case sexID = "sex_id"
        case forename
        case countryOfBirthID = "country_of_birth_id"
        case issuingCountry = "issuing_country"
        case hairsID = "hairs_id"
        case place
        case languagesSpokenIDS = "languages_spoken_ids"
        case dateOfEvent = "date_of_event"
        case height
        case fatherForename = "father_forename"
        case distinguishingMarks = "distinguishing_marks"
        case birthName = "birth_name"
        case weight
        case entityID = "entity_id"
        case placeOfBirth = "place_of_birth"
        case fatherName = "father_name"
        case name
        case links = "_links"
    }
}

struct Links: Codable {
    let images: downloadLink
}

struct downloadLink: Codable {
    let href: String
}
