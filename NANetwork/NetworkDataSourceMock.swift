//
//  NetworkDataSourceMock.swift
//  NANetwork
//
//  Created by Rodrigo Brauwers on 07/12/23.
//

import Foundation
import NAModels

public class NetworkDataSourceMock : NetworkDataSource {
    
    public static let sources: [Source] = [
        Source(id: "1", name: "", description: "", url: "", category: "", language: "", country: ""),
        Source(id: "2", name: "", description: "", url: "", category: "", language: "", country: "")
    ]
    
    public static let articles: [Article] = [
        Article(author: "James", title: "Article1", description: "", url: "", urlToImage: "", publishedAt: "", content: ""),
        Article(author: "John", title: "Article2", description: "", url: "", urlToImage: "", publishedAt: "", content: "")
    ]
    
    public static let stableNetworkDataSource = NetworkDataSourceMock(sources: sources, articles: articles, shouldFail: false)
    public static let unstableNetworkDataSource = NetworkDataSourceMock(sources: sources, articles: articles, shouldFail: true)
    
    let sources: [Source]
    let articles: [Article]
    let shouldFail: Bool
    
    init(sources: [Source], articles: [Article], shouldFail: Bool) {
        self.sources = sources
        self.articles = articles
        self.shouldFail = shouldFail
    }
    
    public func getSources() async throws -> [Source] {
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        if shouldFail {
            throw URLError(.badServerResponse)
        } else {
            return sources
        }
    }
    
    public func getArticles() async throws -> [Article] {
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        if shouldFail {
            throw URLError(.badServerResponse)
        } else {
            return articles
        }
    }
        
}
