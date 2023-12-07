//
//  NetworkContainer.swift
//  NANetwork
//
//  Created by Rodrigo Brauwers on 07/12/23.
//

import Foundation
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
        
        return self
    }
    
}
