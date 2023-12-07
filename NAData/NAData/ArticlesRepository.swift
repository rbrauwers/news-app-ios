//
//  ArticlesRepository.swift
//  NAData
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import SwiftUI
import NAModels
import NANetwork

public final class ArticlesRepository: ObservableObject {

    private let networkDataSource: NetworkDataSource
    
    public init(networkDataSource: NetworkDataSource) {
        self.networkDataSource = networkDataSource
    }
    
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    @Published public var articles: [Article] = []
    
    @MainActor
    public func load() async {
        error = nil
        isLoading = true
        
        do {
            articles = try await networkDataSource.getArticles()
        }
        catch {
            self.error = error
        }
        
        isLoading = false
    }
    
}

