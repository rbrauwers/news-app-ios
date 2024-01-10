//
//  ArticlesDAOMock.swift
//  NADatabase
//
//  Created by Rodrigo Brauwers on 12/12/23.
//

import Foundation
import NAModels

public class ArticlesDAOMock : ArticlesDAO {
    
    public init() {}
    
    public func insert(article: Article) -> Result<Article, Error> {
        return Result.success((article))
    }
    
    public func upsert(article: Article) -> Result<Article, Error>  {
        return Result.success((article))
    }
    
    public func load() -> Result<[Article], Error> {
        return Result.success([])
    }
    
    public func loadAsync() async -> Result<[Article], Error> {
        return Result.success([])
    }
    
    public func updateLiked(articleId: Int, liked: Bool) -> Result<NAModels.Article, NAModels.NADatabaseErrors> {
        return Result.failure(.dataNotFound)
    }
    
}
