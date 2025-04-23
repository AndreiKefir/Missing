//
//  CoreDataManager.swift
//  Missing
//
//  Created by Andy Kefir on 12/04/2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedPersons")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("CoreData load error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

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

    func fetchPerson(by id: String?) -> Person? {
        guard let id = id else { return nil }
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "personID == %@", id)
        request.fetchLimit = 1
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
