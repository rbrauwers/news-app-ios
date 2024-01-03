//
//  SourceDetailsView.swift
//  NASources
//
//  Created by Rodrigo Brauwers on 02/01/24.
//

import Foundation
import SwiftUI
import NACommon
import NAModels

struct SourceDetailsView : View {
    let source: SourceUI
        
    var body: some View {
        Form {
            FormItem(title: "Name", value: source.name)
            FormItem(title: "Category", value: source.category)
            FormItem(title: "Language", value: source.language)
            FormItem(title: "Description", value: source.description)
                .frame(maxHeight: 200)
        }
        .backport.toolbarTitle("Source details")
    }
}


private struct FormItem : View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.headline)
            
            Spacer(minLength: 32)
            
            Text(value)
                .font(.body)
                .minimumScaleFactor(0.5)
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }.frame(maxHeight: .infinity)
    }
    
}


#Preview("Source details") {
    let source = SourceUI(
        source: Source(
            id: "1",
            name: "Bob Dylan",
            description: "sfksdjf klsjfdkjskdj fklsjdlkfjkls djflksjklfjslkdjf klsjkdfjskldfj klsdjfkl jsdklfjlskd jfklsdjflk jslkfjls jfljs sfjskdf jksdjfkls lkfjlksjfj jksdfj",
            url: "",
            category: "business",
            language: "en",
            country: "en")
    )
    
    return SourceDetailsView(source: source)
}
