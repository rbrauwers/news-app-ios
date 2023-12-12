//
//  ArticlesRepository.swift
//  NAData
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import SwiftUI
import NADatabase
import NAModels
import NANetwork

public final class ArticlesRepository: ObservableObject {

    private let networkDataSource: NetworkDataSource
    private let articlesDAO: ArticlesDAO
    
    public init(networkDataSource: NetworkDataSource, articlesDAO: ArticlesDAO) {
        self.networkDataSource = networkDataSource
        self.articlesDAO = articlesDAO
    }
    
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    @Published public var articles: [Article] = []
    
    @MainActor
    public func load() async {
        error = nil
        isLoading = true
        
        if #available(iOS 15.0, *) {
            let result = await articlesDAO.loadAsync()
            if case .success(let data) = result {
                articles = data
            }
        }
        
        do {
            articles = try await networkDataSource.getArticles()
            articles.forEach { article in
                articlesDAO.upsert(article: article)
            }
        }
        catch {
            self.error = error
        }
        
        isLoading = false
    }
    
}

