//
//  ArticleEntity+CoreDataClass.swift
//  NADatabase
//
//  Created by Rodrigo Brauwers on 12/12/23.
//
//

import Foundation
import CoreData


public class ArticleEntity: NSManagedObject {

    private static let entityName = "ArticleEntity"
    
}


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: ArticleEntity.entityName)
    }
    
    @nonobjc public class func fetchRequest(articleId: Int) -> NSFetchRequest<ArticleEntity> {
        let request = fetchRequest()
        let id = NSNumber(value: articleId)
        request.predicate = NSPredicate(format: "customId == %ld", id.int64Value)
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
}

extension ArticleEntity : Identifiable {

}
