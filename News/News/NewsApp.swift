//
//  NewsApp.swift
//  News
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import SwiftUI
import NAData
import NAModels
import NAProfile

@main
struct WeatherProAppWrapper {
    static func main() {
        Task {
            await SourcesRepository.shared.load()
            await ArticlesRepository.shared.load()
        }
        
        // Fixes an odd behaviour with TabItem which content is (some view(s) + a list view)
        // https://developer.apple.com/forums/thread/690563
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
        }
        
        if #available(iOS 14.0, *) {
            NewsApp.main()
        }
        else {
            UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(SceneDelegate.self))
        }
    }
}

//@main
@available(iOS 14.0, *)
struct NewsApp: App {
    
    @StateObject private var appState = AppState(user: User(name: "Rodrigo"))
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appState)
        }
    }
}
