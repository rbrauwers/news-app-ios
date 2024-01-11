//
//  HeadlinesContainer.swift
//  NAHeadlines
//
//  Created by Rodrigo Brauwers on 09/01/24.
//

import Foundation
import Swinject
import NAData

public extension Container {
    
    @discardableResult
    func registerHeadlinesContainer() -> Container {
        register(ArticlesViewModel.self) { resolver in
            guard let repository = resolver.resolve(ArticlesRepository.self) else {
                fatalError("Could not resolve ArticlesRepository dependency")
            }
            
            return ArticlesViewModel(repository: repository)
        }.inObjectScope(.container)
        
        return self
    }
    
}
