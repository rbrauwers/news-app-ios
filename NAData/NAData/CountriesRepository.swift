//
//  CountriesRepository.swift
//  NAData
//
//  Created by Rodrigo Brauwers on 03/01/24.
//

import Foundation
import NAModels
import NANetwork

public protocol CountriesRepository {
    func getCountry(code: String) async -> Result<Country, DataError>
}

final class DefaultCountriesRepository : CountriesRepository {
    
    private let graphQLDataSource: GraphQLDataSource
    
    init(graphQLDataSource: GraphQLDataSource) {
        self.graphQLDataSource = graphQLDataSource
    }
    
    func getCountry(code: String) async -> Result<Country, DataError> {
        return await graphQLDataSource.getCountry(code: code)
    }
    
}
