//
//  SourceDetailsView.swift
//  NASources
//
//  Created by Rodrigo Brauwers on 02/01/24.
//

import Foundation
import SwiftUI
import Swinject
import NACommon
import NAData
import NAModels
import NANetwork

struct SourceDetailsView : View {
    let source: SourceUI
        
    var body: some View {
        Content(source: source)
            .backport.toolbarTitle("Source details")
            .environmentObject(
                globalContainer.resolve(SourceDetailsViewModel.self)!
            )
    }
    
}

struct Content : View {
    
    @EnvironmentObject private var viewModel: SourceDetailsViewModel
    private let source: SourceUI
    
    public init(source: SourceUI) {
        self.source = source
    }
    
    var body: some View {
        return Form {
            Section(header: Text("Source Details", bundle: Bundle.naSources)) {
                FormItem(title: "Name", value: source.name)
                FormItem(title: "Category", value: source.category)
                FormItem(title: "Language", value: source.language)
                FormItem(title: "Description", value: source.description)
                    .frame(maxHeight: 200)
            }
            Section(header: Text("Country", bundle: Bundle.naSources)) {
                switch viewModel.countryUiState {
                case .loading:
                    if #available(iOS 14.0, *) {
                        ProgressView()
                    } else {
                        Text("Loading")
                    }
                case .error(let title):
                    Text(title)
                        .foregroundColor(.red)
                case .success(let country):
                    FormItem(title: "Name", value: country.name)
                    FormItem(title: "Continent", value: country.continent)
                    FormItem(title: "States count", value: String(country.statesCount ?? 0))
                    FormItem(title: "Flag", value: country.emoji)
                }
            }
        }
        .backport.toolbarTitle("Source Details", bundle: Bundle.naSources)
        .onAppear {
            viewModel.loadCountry(code: source.country.uppercased())
        }
    }
    
}


private struct FormItem : View {
    let title: LocalizedStringKey
    let value: String?
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title, bundle: Bundle.naSources)
                .font(.headline)
            
            Spacer(minLength: 32)
            
            Text("")
            
            Text(value ?? "N/A")
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
            country: "fr")
    )
    
    globalContainer
        .registerNetworkDependencies(uiTesting: true)
        .registerDataDependencies()
        .registerSourcesDependencies()
        
    
    return SourceDetailsView(source: source)
}
