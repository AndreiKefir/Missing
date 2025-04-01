//
//  People.swift
//  Missing
//
//  Created by Andy Kefir on 01/04/2025.
//

import Foundation

struct Notices: Codable {
    let total: Int
    let embedded: Embedded
    let links: PeopleLinks

    enum CodingKeys: String, CodingKey {
        case total
        case embedded = "_embedded"
        case links = "_links"
    }
}

struct Embedded: Codable {
    let notices: [Notice]
}

struct Notice: Codable {
    let dateOfBirth: String?
    let nationalities: [String]?
    let name: String?
    let forename: String?
    let entityID: String
    let links: NoticeLinks

    enum CodingKeys: String, CodingKey {
        case dateOfBirth = "date_of_birth"
        case nationalities, name, forename
        case entityID = "entity_id"
        case links = "_links"
    }
}

struct NoticeLinks: Codable {
    let linkSelf, images, thumbnail: Link?

    enum CodingKeys: String, CodingKey {
        case linkSelf = "self"
        case images, thumbnail
    }
}

struct Link: Codable {
    let href: String
}

struct PeopleLinks: Codable {
    let next: Link?
}
