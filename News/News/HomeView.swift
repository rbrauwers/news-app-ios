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
        if #available(iOS 14.0, *) {
            TabViewIOS14()
        }
    }
}

@available(iOS 14.0, *)
struct TabViewIOS14: View {
    @State private var selectedTab = SelectedTab.headlines
    @State private var title = SelectedTab.headlines.rawValue.capitalized
            
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ArticlesView()
                    .tag(SelectedTab.headlines)
                    .customToolbar(title: "Headlines")
            }
            .tabItem {
                Label("Headlines", systemImage: "newspaper")
            }

            NavigationView {
                SourcesView()
                    .tag(SelectedTab.sources)
                    .customToolbar(title: "Sources")
            }
            .tabItem {
                Label("Sources", systemImage: "person.2")
            }
            
        }
        .onChange(of: selectedTab, perform: { value in
            title = selectedTab.rawValue.capitalized
        })
    }
    
}

private extension View {
    
    @available(iOS 14.0, *)
    func customToolbar(title: String) -> some View {
        return self.toolbar {
            ToolbarItem(placement: .principal) {
                Text(title).font(.largeTitle)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
            }
        }
    }
    
}

#Preview {
    HomeView()
}

