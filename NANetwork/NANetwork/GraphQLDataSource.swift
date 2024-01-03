//
//  GraphQLDataSource.swift
//  NANetwork
//
//  Created by Rodrigo Brauwers on 03/01/24.
//

import Foundation
import Apollo
import NAModels

public protocol GraphQLDataSource {
    func getCountry(code: String) async -> Result<Country, DataError>
}

final class DefaultGraphQLDataSource : GraphQLDataSource {
    
    private let apolloClient: ApolloClient
    
    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }
    
    func getCountry(code: String) async -> Result<Country, DataError> {
        await withCheckedContinuation { continuation in
            apolloClient.fetch(query: NewsAppGraphQL.GetCountryQuery(code: code)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let country = graphQLResult.data?.country {
                        continuation.resume(returning: .success(country.toModel()))
                    } else {
                        continuation.resume(returning: .failure(.invalidData))
                    }
                case .failure(let error):
                    debugPrint("Get country failure: \(error)")
                    continuation.resume(returning: .failure(.networkError))
                }
            }
        }
    }
}

private extension NewsAppGraphQL.GetCountryQuery.Data.Country {
    
    func toModel() -> Country {
        return Country(
            name: self.name,
            continent: self.continent.name,
            statesCount: self.states.count,
            emoji: self.emoji
        )
    }
    
}
