//
//  ArticleEntity+CoreDataClass.swift
//  NADatabase
//
//  Created by Rodrigo Brauwers on 12/12/23.
//
//

import Foundation
import CoreData
import NAModels

public class ArticleEntity: NSManagedObject {

    private static let entityName = "ArticleEntity"
    
    enum CodingKeys: String, CodingKey {
        case author, title, description, url, urlToImage, publishedAt, content, liked, customId
    }
}


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        let request = NSFetchRequest<ArticleEntity>(entityName: ArticleEntity.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: CodingKeys.publishedAt.rawValue, ascending: false)]
        return request
    }
    
    @nonobjc public class func fetchRequest(articleId: Int) -> NSFetchRequest<ArticleEntity> {
        let request = fetchRequest()
        let id = NSNumber(value: articleId)
        request.predicate = NSPredicate(format: "\(ArticleEntity.CodingKeys.customId.rawValue) == %ld", id.int64Value)
        request.fetchLimit = 1
        return request
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var content: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var customId: Int
    @NSManaged public var liked: Bool
}

extension ArticleEntity : Identifiable {

}
