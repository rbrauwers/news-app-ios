//
//  ArticlesRepository.swift
//  NAData
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import Combine
import SwiftUI
import NACommon
import NADatabase
import NAModels
import NANetwork

public protocol ArticlesRepository {
    typealias DATA = StatefulData<[Article]>
    
    func load() async
    
    func updateLiked(articleId: Int, liked: Bool) -> Result<Article, NADatabaseErrors>
    
    @available(iOS 15.0, *)
    func updateLikes(_ likes: [Int : Bool]) async
    
    var data: DATA { get }
    var publishedData: Published<DATA> { get }
    var dataPublisher: Published<DATA>.Publisher { get }
}

final class DefaultArticlesRepository: ArticlesRepository, ObservableObject {

    private let networkDataSource: NetworkDataSource
    private let articlesDAO: ArticlesDAO
    
    public init(networkDataSource: NetworkDataSource, articlesDAO: ArticlesDAO) {
        self.networkDataSource = networkDataSource
        self.articlesDAO = articlesDAO
        
        Task {
            await loadFromDAO()
        }
    }
    
    @Published public var data: ArticlesRepository.DATA = .loading
    public var publishedData: Published<ArticlesRepository.DATA> { _data }
    public var dataPublisher: Published<ArticlesRepository.DATA>.Publisher { $data }
    
    @MainActor
    public func load() async {
        data = .loading

        do {
            let articles = try await networkDataSource.getArticles()
            
            articles.forEach { article in
                articlesDAO.upsert(article: article)
            }
            
            await loadFromDAO()
        }
        catch {
            data = .error(error)
        }
    }
    
    @MainActor
    public func updateLiked(articleId: Int, liked: Bool) -> Result<Article, NADatabaseErrors> {
        let result = articlesDAO.updateLiked(articleId: articleId, liked: liked)
        
        if case .success(let article) = result {
            publishArticle(article: article)
        }

        return result
    }
    
    @MainActor
    @available(iOS 15.0, *)
    public func updateLikes(_ likes: [Int : Bool]) async {
        let result = await articlesDAO.updateLikes(likes)
        if case .success(let articles) = result {
            data = .success(articles)
        }
    }
    
    @MainActor
    private func loadFromDAO() async {
        if #available(iOS 15.0, *) {
            let result = await articlesDAO.loadAsync()
            if case .success(let articles) = result {
                data = .success(articles)
            }
        }
    }
    
    @MainActor
    private func publishArticle(article: Article) {
        guard case let DATA.success(articles) = data,
              let index = (articles.firstIndex { $0.id == article.id })
        else {
            return
        }
        
        var mutableArticles = articles
        mutableArticles[index] = article
        data = .success(mutableArticles)
    }
    
}
