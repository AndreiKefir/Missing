//
//  SelectSountry.swift
//  Missing
//
//  Created by Andy Kefir on 07/04/2025.
//

import Foundation

protocol NationSelectDelegate: AnyObject {
    func didSelectNation(_ nation: String)
}

protocol SearchFilterDelegate: AnyObject {
    func didUpdateSearchQuery(_ queryItems: [URLQueryItem])
}
