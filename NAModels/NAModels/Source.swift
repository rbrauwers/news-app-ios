//
//  Source.swift
//  NAModels
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation

public struct Source : Decodable, Identifiable {
    public let id: String
    public let name: String?
    public let description: String?
    public let url: String?
    public let category: String?
    public let language: String?
    public let country: String?
    
    public init(id: String, name: String?, description: String?, url: String?, category: String?, language: String?, country: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
}
