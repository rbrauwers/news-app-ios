//
//  SourcesResponse.swift
//  NAModels
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation

public struct SourcesResponse : Decodable {
    public let status: String
    public let sources: [Source]
}
