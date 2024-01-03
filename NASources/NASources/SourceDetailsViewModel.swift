//
//  SourceDetailsViewModel.swift
//  NASources
//
//  Created by Rodrigo Brauwers on 03/01/24.
//

import Foundation
import SwiftUI
import NAData
import NAModels

class SourceDetailsViewModel : ObservableObject {
    
    private let countriesRepository: CountriesRepository
    
    @Published var countryUiState: CountryUiState = .loading
    
    init(countriesRepository: CountriesRepository) {
        self.countriesRepository = countriesRepository
    }
 
    @MainActor
    public func loadCountry(code: String) {
        Task {
            countryUiState = .loading
            let result = await countriesRepository.getCountry(code: code)
            
            switch result {
            case .success(let country):
                countryUiState = .success(country: country)
            case.failure(let error):
                countryUiState = .error(title: error.localizedDescription)
            }
        }
    }
    
}

enum CountryUiState {
    case loading
    case error(title: String)
    case success(country: Country)
}
