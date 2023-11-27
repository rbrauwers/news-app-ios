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

@MainActor
public final class ArticlesRepository: ObservableObject {
    
    public static let shared = ArticlesRepository()
    
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    @Published public var articles: [Article] = []
    
    private let networkDataSource = NetworkDataSource()
    
    public func load() async {
        error = nil
        isLoading = true
        
        do {
            let items = try await networkDataSource.getArticles()
            articles = Array(Set(items))
        }
        catch {
            self.error = error
        }
        
        isLoading = false
    }
    
}

