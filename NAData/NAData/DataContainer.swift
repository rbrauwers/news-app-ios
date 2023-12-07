//
//  DataContainer.swift
//  NAData
//
//  Created by Rodrigo Brauwers on 07/12/23.
//

import Foundation
import Swinject
import NANetwork

public extension Container {
    
    @discardableResult
    func registerDataDependencies() -> Container {
        register(ArticlesRepository.self) { resolver in
            guard let networkDataSource = resolver.resolve(NetworkDataSource.self) else {
                fatalError("Could not resolve network data source")
            }
            return ArticlesRepository(networkDataSource: networkDataSource)
        }
        .inObjectScope(.container)
        
        register(SourcesRepository.self) { resolver in
            guard let networkDataSource = resolver.resolve(NetworkDataSource.self) else {
                fatalError("Could not resolve network data source")
            }
            return SourcesRepository(networkDataSource: networkDataSource)
        }
        .inObjectScope(.container)
        
        return self
    }
    
}
