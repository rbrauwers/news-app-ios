//
//  SourcesRepository.swift
//  NAData
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import NAModels
import NANetwork

public final class SourcesRepository: ObservableObject {
    
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    @Published public var sources: [Source] = []
    
    private let networkDataSource: NetworkDataSource
    
    public init(networkDataSource: NetworkDataSource) {
        self.networkDataSource = networkDataSource
    }
    
    @MainActor
    public func load() async {
        error = nil
        isLoading = true
        
        do {
            sources = try await networkDataSource.getSources()
        }
        catch {
            self.error = error
        }
        
        isLoading = false
    }
    
}
