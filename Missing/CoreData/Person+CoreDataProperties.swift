//
//  Person+CoreDataProperties.swift
//  Missing
//
//  Created by Andy Kefir on 14/04/2025.
//
//

import Foundation
import CoreData


extension Person : Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var dateOfBirth: String?
    @NSManaged public var familyName: String?
    @NSManaged public var forename: String?
    @NSManaged public var nationality: String?
    @NSManaged public var personID: String
    @NSManaged public var photo: Data?

}
