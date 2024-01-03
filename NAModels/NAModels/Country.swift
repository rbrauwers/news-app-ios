//
//  Country.swift
//  NAModels
//
//  Created by Rodrigo Brauwers on 03/01/24.
//

import Foundation

public struct Country {
    public let name: String?
    public let continent: String?
    public let statesCount: Int?
    public let emoji: String?
    
    public init(name: String?, continent: String?, statesCount: Int?, emoji: String?) {
        self.name = name
        self.continent = continent
        self.statesCount = statesCount
        self.emoji = emoji
    }
}
