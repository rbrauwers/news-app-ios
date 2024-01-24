//
//  SourcesView.swift
//  NASources
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import SwiftUI
import NACommon
import NAData
import NAModels

public struct SourcesView : View {
    public init() {}
    
    public var body: some View {
        SourcesViewContent()
    }
    
}

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
                if #available(iOS 14.0, *) {
                    ProgressView()
                }
            }
            
            Links()
            
            PlayerView()
            
            SourcesList(sources: repository.sources.compactMap {
                SourceUI(source: $0)
            })
        }
    }
    
}

struct SourcesList : View {
    
    let sources: [SourceUI]

    @State private var searchTerm = ""
    
    private var filteredSources : [SourceUI] {
        if searchTerm.isEmpty {
            return sources
        } else {
            return sources.filter { source in
                source.name.localizedCaseInsensitiveContains(searchTerm) ||
                source.category.localizedStandardContains(searchTerm)
            }
        }
    }
    
    var body: some View {
        List(filteredSources, id: \.id) { source in
            SourceItem(source: source)
        }
        .backport.contentUnavailable(condition: filteredSources.isEmpty && !searchTerm.isEmpty, text: searchTerm)
        .backport.searchable(text: $searchTerm, prompt: "Search sources")
        .listStyle(.plain)
    }
    
}

struct SourceItem : View {
    
    let source: SourceUI
    
    var body: some View {
        NavigationLink(destination: SourceDetailsView(source: source)) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(source.name).font(.headline)
                    Text(source.category).font(.subheadline)
                }
                
                Spacer()
                            
                Text(source.language).font(.caption)
            }
        }
    }
    
}

struct Links : View {
    
    var body: some View {
        Group {
            if #available(iOS 14.0, *) {
                NavigationLink(destination: Screen1()
                    //.environmentObject(Screen1ViewModel())
                ) {
                    Text("Screen1")
                }.buttonStyle(.plain)
                
                Spacer(minLength: 20)
                
                NavigationLink("Other approach screen1") {
                    Screen1()
                        //.environmentObject(Screen1ViewModel())
                }
                
                Spacer(minLength: 20)
            }
        
            if #available(iOS 15.0, *) {
                NavigationLink(destination: Screen2()) {
                    Text("Screen2")
                }.buttonStyle(.bordered)
            }
            
            Spacer(minLength: 20)
            
            if #available(iOS 14.0, *) {
                NavigationLink {
                    Screen2()
                } label: {
                    Label("Other approach screen2", systemImage: "folder")
                }
            }
        }
    }
    
}

@available(iOS 14.0, *)
struct Screen1 : View {
    @StateObject private var viewModel: Screen1ViewModel = Screen1ViewModel()
    
    var body: some View {
        Text("Screen1. State: \(viewModel.currentState)")
    }
    
}

struct Screen2 : View {

    var body: some View {
        Text("Screen2")
    }
    
}

class Screen1ViewModel : ObservableObject {
    
    private static var id = 0
    
    @Published public private(set) var currentState = "Sunny"
    
    @MainActor
    init() {
        Screen1ViewModel.id += 1
        debugPrint("qqq Screen1ViewModel \(Screen1ViewModel.id)")
        makeCloudy()
    }
    
    @MainActor
    private func makeCloudy() {
        Task {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            currentState = "Cloudy"
            
        }
    }
    
}


struct PlayButton: View {
    /// Changes will be propagated through top hierarchy
    @Binding var isPlaying: Bool
    
    /// Changes will not be propagated through top hierarchy
    //@State var isPlaying: Bool
        
    let onButtonClick: () -> ()
    
    var body: some View {
        Button(action: {
            self.isPlaying.toggle()
            
            Task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    onButtonClick()
                }
            }
        }) {
            Image(systemName: isPlaying ? "pause.circle" : "play.circle")
        }
    }
}

struct PlayerView: View {
    @State private var isPlaying: Bool = true

    var body: some View {
        VStack {
            Text("Is playing: \(isPlaying ? "true" : "false")")
            /// Pass a binding
            PlayButton(isPlaying: $isPlaying, onButtonClick: handleButtonClick)
            
            /// Pass a state
            //PlayButton(isPlaying: isPlaying, onButtonClick: handleButtonClick)
        }
    }
    
    func handleButtonClick() {
        debugPrint("handleButtonClick")
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
