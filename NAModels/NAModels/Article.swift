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
    public var id: Int
    
    private enum CodingKeys: String, CodingKey {
        case author, title, description, url, urlToImage, publishedAt, content
    }
    
    public init(author: String?,
                title: String?,
                description: String?,
                url: String?,
                urlToImage: String?,
                publishedAt: String?,
                content: String?,
                id: Int
    ) {
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.id = id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.id = "\(publishedAt ?? "")\(author ?? "")".hash
    }
    
}

private extension String? {
    
    func orEmpty() -> String {
        return self ?? ""
    }
    
}
