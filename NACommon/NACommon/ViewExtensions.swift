//
//  ViewExtensions.swift
//  NACommon
//
//  Created by Rodrigo Brauwers on 29/12/23.
//

import Foundation
import SwiftUI

public extension Bool {
    static var iOS15OrLater: Bool {
        guard #available(iOS 15, *) else {
            return true
        }
        
        return false
    }
}

public extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder func apply<Content: View>(transform: (Self) -> Content) -> some View {
        transform(self)
    }
}
