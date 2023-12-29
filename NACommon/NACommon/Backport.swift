//
//  Backport.swift
//  NACommon
//
//  Created by Rodrigo Brauwers on 29/12/23.
//

import Foundation
import SwiftUI

public struct Backport<Content : View> {
    let content: Content
}

public extension View {
    var backport: Backport<Self> { Backport(content: self) }
}

public extension Backport {
    
    @ViewBuilder func badge(_ count: Int) -> some View {
        if #available(iOS 15, *) {
            content.badge(count)
        } else {
            content
        }
    }
    
    
    @ViewBuilder func searchable(text: Binding<String>, prompt: String) -> some View {
        if #available(iOS 15, *) {
            content.searchable(text: text, prompt: prompt)
        } else {
            content
        }
    }
    
    @ViewBuilder func accessibilityIdentifier(_ identifier: String) -> some View {
        if #available(iOS 14.0, *) {
            content.accessibilityIdentifier(identifier)
        } else {
            content
        }
    }
    
    @ViewBuilder func accessibilityLabel(_ label: String) -> some View {
        if #available(iOS 14.0, *) {
            content.accessibilityLabel(label)
        } else {
            content
        }
    }
    
    @ViewBuilder func hiddenListRowSeparator() -> some View {
        if #available(iOS 15.0, *) {
            content.listRowSeparator(.hidden)
        } else {
            content
        }
    }
    
    @ViewBuilder func tint(_ color: Color) -> some View {
        if #available(iOS 16.0, *) {
            content.tint(color)
        } else {
            content
        }
    }
    
    
}
