//
//  NASources+Bundle.swift
//  NASources
//
//  Created by Rodrigo Brauwers on 24/01/24.
//

import Foundation

extension Bundle {
    static let naSources = Bundle(for: BundleBinder.self)
}

private class BundleBinder {}
