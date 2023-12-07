//
//  SourcesView.swift
//  NASources
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import SwiftUI
import NAData
import NAModels

public struct SourcesView : View {
    public init() {}
    
    public var body: some View {
        if #available(iOS 14, *) {
            SourcesViewContent()
        } else {
            SourcesViewLegacyContent()
        }
    }
    
}

@available(iOS 14, *)
struct SourcesViewContent : View {
    @EnvironmentObject private var repository: SourcesRepository
    
    var body: some View {
        VStack(alignment: .center) {
            if let error = repository.error {
                Text(error.localizedDescription)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Color.red)
                    .foregroundColor(.white)
            }
            
            if repository.isLoading {
                ProgressView()
            }
            
            SourcesList(sources: repository.sources.compactMap {
                SourceUI(source: $0)
            })
        }
    }
    
}

struct SourcesViewLegacyContent : View {

    var body: some View {
        Text("SourcesViewLegacyContent")
    }
    
}

struct SourcesList : View {
    
    let sources: [SourceUI]
    
    var body: some View {
        List(sources) {
            SourceItem(source: $0)
        }
    }
    
}

struct SourceItem : View {
    
    let source: SourceUI
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(source.name).font(.headline)
                Text(source.category).font(.subheadline)
            }
            
            Spacer()
                        
            Text(source.language).font(.caption)
            Image(systemName: "chevron.right")
        }
    }
    
}

#Preview("Sources list") {
    let source = SourceUI(
        source: Source(
            id: "1",
            name: "Bob Dylan",
            description: "",
            url: "",
            category: "business",
            language: "en",
            country: "en")
    )
    
    let source2 = SourceUI(
        source: Source(
            id: "2",
            name: "John Smith",
            description: "",
            url: "",
            category: "business",
            language: "en",
            country: "en")
    )
    
    return SourcesList(sources: [source, source2])
}
