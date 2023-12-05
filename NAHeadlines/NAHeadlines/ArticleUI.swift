//
//  ArticleUI.swift
//  NAHeadlines
//
//  Created by Rodrigo Brauwers on 27/11/23.
//

import Foundation
import NAModels

struct ArticleUI : Identifiable, Equatable {
    
    let id: Int
    let author: String
    let content: String
    let publishedAt: String?
    let urlToImage: String?
    
    static var inputFormatter: ISO8601DateFormatter {
        get {
            ISO8601DateFormatter()
        }
    }
    
    static var outputFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
            return formatter
        }
    }
    
    init(article: Article) {
        id = article.id
        author = article.author ?? "N/A"
        content = article.content ?? "N/A"
        urlToImage = article.urlToImage
        
        if let publishedAt = article.publishedAt, let date = ArticleUI.inputFormatter.date(from: publishedAt) {
            self.publishedAt = ArticleUI.outputFormatter.string(from: date)
        } else {
            self.publishedAt = nil
        }
    }
    
}
