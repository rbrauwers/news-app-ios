//
//  HomeView.swift
//  News
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import SwiftUI
import NAHeadlines
import NANetwork
import NASources
import NAProfile

private enum SelectedTab: String, CaseIterable {
    case headlines
    case sources
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                TabViewIOS14()
            }
        }
    }
}

@available(iOS 14.0, *)
struct TabViewIOS14: View {
    @State private var selectedTab = SelectedTab.headlines
    @State private var title = SelectedTab.headlines.rawValue.capitalized
            
    var body: some View {
        TabView(selection: $selectedTab) {
            ArticlesView()
                .tabItem {
                    Label("Headlines", systemImage: "newspaper")
                }
                .tag(SelectedTab.headlines)
            
            SourcesView()
                .tabItem {
                    Label("Sources", systemImage: "person.2")
                }
                .tag(SelectedTab.sources)
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text(title).font(.largeTitle)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle")
                }
            }
        }
        .onChange(of: selectedTab, perform: { value in
            title = selectedTab.rawValue.capitalized
        })
    }
    
}

#Preview {
    HomeView()
}

