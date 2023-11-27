//
//  HeadlinesResponse.swift
//  NAModels
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation

public struct HeadlinesResponse : Decodable {
    public let status: String
    public let totalResults: Int
    public let articles: [Article]
}
