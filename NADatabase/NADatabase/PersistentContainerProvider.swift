//
//  PersistentContainerProvider.swift
//  NADatabase
//
//  Created by Rodrigo Brauwers on 12/12/23.
//

import Foundation
import CoreData

public protocol PersistentContainerProvider {
    var persistentContainer: NSPersistentContainer { get }
}

class DefaultPersistentContainerProvider : PersistentContainerProvider {
   
    lazy var persistentContainer: NSPersistentContainer = {
        guard let url = Bundle.naDatabase.url(forResource: "Database", withExtension: "momd") else {
            fatalError("Unable to get Database url")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Unable to get managed object model for Database")
        }
        
        let container = NSPersistentContainer(name: "Database", managedObjectModel: managedObjectModel)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
}
