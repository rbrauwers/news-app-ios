//
//  StatefulData.swift
//  NACommon
//
//  Created by Rodrigo Brauwers on 09/01/24.
//

import Foundation

public enum StatefulData<T> {
    case loading
    case error(Error)
    case success(T)
    
    public func map<S>(transform: (T) -> S) -> StatefulData<S> {
        switch self {
        case .loading:
            return .loading
        case .error(let error):
            return .error(error)
        case .success(let data):
            return .success(transform(data))
        }
    }
}

