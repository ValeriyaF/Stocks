//
//  CoreDataManager.swift
//  Stocks
//
//  Created by Valeriya Fisenko on 06.03.2021.
//  Copyright © 2021 valeri. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Stocks")


        container.loadPersistentStores(completionHandler: { (storeDescription, error) in

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func save(completion: (NSManagedObjectContext) -> Void) throws {
        let context = persistentContainer.viewContext
        completion(context)
        try context.save()
    }

    func fetch<Entity: NSManagedObject>(entity: Entity.Type) throws -> [Any] {
        return try persistentContainer.viewContext.fetch(Entity.fetchRequest())
    }

}
