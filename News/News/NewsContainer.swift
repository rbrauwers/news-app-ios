//
//  NewsContainer.swift
//  News
//
//  Created by Rodrigo Brauwers on 10/01/24.
//

import Foundation
import Swinject
import NAData

public extension Container {
    
    @discardableResult
    func registerNewsContainer() -> Container {
        register(SettingsViewModel.self) { resolver in
            guard let repository = resolver.resolve(ArticlesRepository.self) else {
                fatalError("Could not resolve ArticlesRepository dependency")
            }
            
            return SettingsViewModel(repository: repository)
        }.inObjectScope(.transient)
        
        return self
    }
    
}

