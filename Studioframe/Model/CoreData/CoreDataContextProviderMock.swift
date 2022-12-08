//
//  CoreDataContextProviderMock.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 08/12/2022.
//

import Foundation
import CoreData

class CoreDataContextProviderMock: CoreDataContextProviderProtocol {
    
    static let shared = CoreDataContextProvider()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    func save() throws {
        try viewContext.save()
    }
    
    func delete(_ object: NSManagedObject) {
        viewContext.delete(object)
    }
    
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        throw MockErrorEnum.error
    }
}
