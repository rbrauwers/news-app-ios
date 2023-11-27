//
//  Article.swift
//  NAModels
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation


public struct Article : Decodable, Identifiable, Hashable {
    
    public let author: String?
    public let title: String?
    public let description: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
    public let content: String?
    
    public var id: Int {
        get {
            "\(author.orEmpty())\(title.orEmpty())\(description.orEmpty())\(url.orEmpty())\(urlToImage.orEmpty())\(publishedAt.orEmpty())\(content.orEmpty())".hashValue
        }
    }
    
    public init(author: String?, title: String?, description: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

private extension String? {
    
    func orEmpty() -> String {
        return self ?? ""
    }
    
}
