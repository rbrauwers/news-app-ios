//
//  SourcesContainer.swift
//  NASources
//
//  Created by Rodrigo Brauwers on 03/01/24.
//

import Foundation
import Swinject
import NAData

public extension Container {
    
    @discardableResult
    func registerSourcesDependencies() -> Container {
        register(SourceDetailsViewModel.self) { resolver in
            guard let countriesRepository = resolver.resolve(CountriesRepository.self) else {
                fatalError("Could not resolve CountriesRepository")
            }
            
            return SourceDetailsViewModel(countriesRepository: countriesRepository)
        }

        return self
    }
    
}
