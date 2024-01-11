//
//  Erros.swift
//  NAModels
//
//  Created by Rodrigo Brauwers on 03/01/24.
//

import Foundation

public enum DataError: Error {
    case networkError
    case invalidData
}

public enum NADatabaseErrors : Error {
    case dataNotFound
    case transactionError
}
