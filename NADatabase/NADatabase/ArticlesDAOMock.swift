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
    
    public func insert(article: Article) -> Result<Void, Error> {
        return Result.success(())
    }
    
    public func upsert(article: Article) {
        
    }
    
    public func load() -> Result<[Article], Error> {
        return Result.success([])
    }
    
    public func loadAsync() async -> Result<[Article], Error> {
        return Result.success([])
    }
    
}
