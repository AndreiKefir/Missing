//
//  PersonImagesLink.swift
//  Missing
//
//  Created by Andy Kefir on 03/04/2025.
//

import Foundation

struct PersonImageslink: Codable {
    let embedded: EmbeddedPhotos

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedPhotos: Codable {
    let images: [PersonImage]
}

struct PersonImage: Codable {
    let imageLinks: ImageLink

    enum CodingKeys: String, CodingKey {
        case imageLinks = "_links"
    }
}

struct ImageLink: Codable {
    let linksSelf: PhotoLink

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

struct PhotoLink: Codable {
    let href: String
}
