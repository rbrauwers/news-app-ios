//
//  NetworkContainer.swift
//  NANetwork
//
//  Created by Rodrigo Brauwers on 07/12/23.
//

import Foundation
import Apollo
import Swinject

public extension Container {
    
    func registerNetworkDependencies(uiTesting: Bool) -> Container {
        if uiTesting {
            register(NetworkDataSource.self) { _ in
                NetworkDataSourceMock.stableNetworkDataSource
            }
        } else {
            register(NetworkDataSource.self) { _ in
                DefaultNetworkDataSource()
            }
        }
        
        register(ApolloClient.self) { _ in
            ApolloClient(url: URL(string: "https://countries.trevorblades.com/graphql")!)
        }
        
        register(GraphQLDataSource.self) { resolver in
            guard let apolloClient = resolver.resolve(ApolloClient.self) else {
                fatalError("Could not resolve Apollo client")
            }
            
            return DefaultGraphQLDataSource(apolloClient: apolloClient)
        }
        
        return self
    }
    
}
