//
//  CoreDataManager.swift
//  Missing
//
//  Created by Andy Kefir on 12/04/2025.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func createPerson() -> Person
    func fetchPerson(by id: String) -> Person?
    func fetchAllPersons() -> [Person]
    func saveContext()
    func deletePerson(by id: String)
}

final class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedPersons")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("CoreData load error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private init() {}

    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully.")
            } catch {
                let nserror = error as NSError
                print("CoreData save error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createPerson() -> Person {
        return Person(context: viewContext)
    }

    func fetchPerson(by id: String) -> Person? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "personID == %@", id)
        return try? viewContext.fetch(request).first
    }

    func fetchAllPersons() -> [Person] {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        return (try? viewContext.fetch(request)) ?? []
    }

    func deletePerson(by id: String) {
        if let person = fetchPerson(by: id) {
            viewContext.delete(person)
            saveContext()
            print("Person deleted successfully.")
        }
    }
}
