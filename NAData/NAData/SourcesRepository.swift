//
//  SourcesRepository.swift
//  NAData
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import SwiftUI
import NAModels
import NANetwork

@MainActor
public final class SourcesRepository: ObservableObject {
    
    public static let shared = SourcesRepository()
    
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    @Published public var sources: [Source] = []
    
    private let networkDataSource = NetworkDataSource()
    
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
