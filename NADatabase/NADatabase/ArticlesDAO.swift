//
//  ArticlesDAO.swift
//  NADatabase
//
//  Created by Rodrigo Brauwers on 12/12/23.
//

import Foundation
import CoreData
import NAModels

public protocol ArticlesDAO {
    
    func insert(article: Article) -> Result<Void, Error>
    
    func upsert(article: Article)
    
    func load() -> Result<[Article], Error>
    
    @available(iOS 15.0, *)
    func loadAsync() async -> Result<[Article], Error>
}

class DefaultArticlesDAO : ArticlesDAO {
    
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func insert(article: Article) -> Result<Void, Error> {
        return Result {
            let _ = article.toEntity(context: persistentContainer.viewContext)
            try persistentContainer.viewContext.save()
        }
    }
    
    func upsert(article: Article) {
        guard let entity = load(articleId: article.id) else {
            let result = insert(article: article)
            return
        }
        
        let result = update(entity: entity, with: article)
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
    
    private func update(entity: ArticleEntity, with article: Article) -> Result<Void, Error> {
        return Result {
            entity.update(with: article)
            try persistentContainer.viewContext.save()
        }
    }
    
    private func load(articleId: Int) -> ArticleEntity? {
        do {
            let request = ArticleEntity.fetchRequest(articleId: articleId)
            return try persistentContainer.viewContext.fetch(request).first
        } catch {
            debugPrint("load(articleId: \(articleId)) error: \(error)")
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
            id: self.customId)
    }
    
    func update(with article: Article) {
        self.author = article.author
        self.title = article.title
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
    }
    
}
