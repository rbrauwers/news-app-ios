//
//  ArticlesDAO.swift
//  NADatabase
//
//  Created by Rodrigo Brauwers on 12/12/23.
//

import Foundation
import CoreData
import OSLog
import NAModels

let logger = Logger(subsystem: "NADatabase", category: "account")

public protocol ArticlesDAO {
    
    func insert(article: Article) -> Result<Article, Error>
    
    @discardableResult
    func upsert(article: Article) -> Result<Article, Error>
    
    func load() -> Result<[Article], Error>
    
    @available(iOS 15.0, *)
    func loadAsync() async -> Result<[Article], Error>
    
    func updateLiked(articleId: Int, liked: Bool) -> Result<Article, NADatabaseErrors>
    
    @available(iOS 15.0, *)
    func updateLikes(_ likes: [Int : Bool]) async -> Result<[Article], Error>
}

class DefaultArticlesDAO : ArticlesDAO {
    
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    @discardableResult
    func insert(article: Article) -> Result<Article, Error> {
        return Result {
            let entity = article.toEntity(context: persistentContainer.viewContext)
            try persistentContainer.viewContext.save()
            return entity.toArticle()
        }
    }
    
    func upsert(article: Article) -> Result<Article, Error> {
        guard let entity = load(articleId: article.id) else {
            return insert(article: article)
        }
        
        return update(entity: entity, with: article, ignoreLocalProperties: true)
    }

    func load() -> Result<[Article], Error> {
        return Result {
            let request = ArticleEntity.fetchRequest()
            return try persistentContainer.viewContext.fetch(request).map { $0.toArticle() }
        }
    }
    
    @available(iOS 15.0, *)
    func loadAsync() async -> Result<[Article], Error> {
        do {
            let articles = try await persistentContainer.viewContext.perform {
                let request = ArticleEntity.fetchRequest()
                return try self.persistentContainer.viewContext.fetch(request).map { $0.toArticle() }
            }
            return Result.success(articles)
        } catch {
            return Result.failure(error)
        }
    }
    
    func updateLiked(articleId: Int, liked: Bool) -> Result<Article, NADatabaseErrors> {
        guard let entity = load(articleId: articleId) else {
            return Result.failure(NADatabaseErrors.dataNotFound)
        }
        
        return Result {
            entity.setValue(liked, forKey: ArticleEntity.CodingKeys.liked.rawValue)
            try persistentContainer.viewContext.save()
            let article = entity.toArticle()
            return article
        }.mapError { error in
            return NADatabaseErrors.transactionError
        }
    }
    
    @available(iOS 15.0, *)
    func updateLikes(_ likes: [Int : Bool]) async -> Result<[Article], Error> {
        do {
            for (id, liked) in likes {
                if let entity = load(articleId: id) {
                    entity.setValue(liked, forKey: ArticleEntity.CodingKeys.liked.rawValue)
                }
            }
            
            try await persistentContainer.viewContext.perform {
                return try self.persistentContainer.viewContext.save()
            }
        } catch {
            return .failure(NADatabaseErrors.transactionError)
        }
        
        return await loadAsync()
    }

    @discardableResult
    private func update(entity: ArticleEntity, with article: Article, ignoreLocalProperties: Bool) -> Result<Article, Error> {
        return Result {
            entity.update(with: article, ignoreLocalProperties: ignoreLocalProperties)
            try persistentContainer.viewContext.save()
            return entity.toArticle()
        }
    }
    
    private func load(articleId: Int) -> ArticleEntity? {
        do {
            let request = ArticleEntity.fetchRequest(articleId: articleId)
            let entity = try persistentContainer.viewContext.fetch(request).first
            return entity
        } catch {
            logger.error("load(articleId: \(articleId)) error: \(error)")
            return nil
        }
    }
    
}

private extension Article {
    
    func toEntity(context: NSManagedObjectContext) -> ArticleEntity {
        let entity = ArticleEntity(context: context)
        entity.author = self.author
        entity.title = self.title
        entity.content = self.content
        entity.url = self.url
        entity.urlToImage = self.urlToImage
        entity.publishedAt = self.publishedAt
        entity.customId = self.id
        entity.liked = self.liked
        return entity
    }
    
}

private extension ArticleEntity {
    
    func toArticle() -> Article {
        return Article(
            author: self.author,
            title: self.title,
            description: self.description,
            url: self.url,
            urlToImage: self.urlToImage,
            publishedAt: self.publishedAt,
            content: self.content,
            id: self.customId,
            liked: self.liked)
    }

    
    /// Update an entity with the model counterpart
    /// - Parameter article: source article to be "copied" from
    /// - Parameter ignoreLocalProperties: wether local properties should be updated or not
    func update(with article: Article, ignoreLocalProperties: Bool) {
        self.author = article.author
        self.title = article.title
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
        
        if !ignoreLocalProperties {
            self.liked = article.liked
        }
    }
    
}
