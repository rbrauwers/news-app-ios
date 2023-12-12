//
//  DatabaseContainer.swift
//  NADatabase
//
//  Created by Rodrigo Brauwers on 12/12/23.
//

import Foundation
import Swinject

public extension Container {
    
    @discardableResult
    func registerDatabaseDependencies() -> Container {
        register(PersistentContainerProvider.self) { _ in
            DefaultPersistentContainerProvider()
        }
        .inObjectScope(.container)
        
        register(ArticlesDAO.self) { resolver in
            guard let persistentContainer = resolver.resolve(PersistentContainerProvider.self)?.persistentContainer else {
                fatalError("Could not resolve persistent container")
            }
            
            return DefaultArticlesDAO(persistentContainer: persistentContainer)
        }.inObjectScope(.container)
        
        return self
    }
    
}
