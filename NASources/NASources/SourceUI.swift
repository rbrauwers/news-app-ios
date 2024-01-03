//
//  SourceUI.swift
//  NASources
//
//  Created by Rodrigo Brauwers on 27/11/23.
//

import Foundation
import NAModels

struct SourceUI : Identifiable, Hashable {
    
    let id: String
    let name: String
    let category: String
    let language: String
    let description: String
    let country: String
    
    init(source: Source) {
        self.id = source.id
        self.name = source.name ?? "N/A"
        self.category = source.category ?? "N/A"
        self.language = source.language ?? "N/A"
        self.description = source.description ?? "N/A"
        self.country = source.country ?? "N/A"
    }
    
}
