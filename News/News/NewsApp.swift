//
//  NewsApp.swift
//  News
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import SwiftUI
import NACommon
import NAData
import NAModels
import NANetwork
import NAProfile
import NAHeadlines
import NASources
import TestUtils
import Swinject

@main
struct WeatherProAppWrapper {
    static func main() {
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
    private let uiTesting: Bool
    
    init() {
        uiTesting = CommandLine.arguments.contains("-UITesting")
        debugPrint("uiTesting: \(uiTesting)")
        buildContainer()
        load()
    }
    
    private func buildContainer() {
        globalContainer
            .registerNetworkDependencies(uiTesting: uiTesting)
            .registerDataDependencies()
            .registerSourcesDependencies()
            .registerHeadlinesContainer()
            .registerNewsContainer()
    }
    
    private func load() {
        Task {
            await globalContainer.resolve(ArticlesRepository.self)?.load()
            await globalContainer.resolve(SourcesRepository.self)?.load()
        }
    }
        
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appState)
                .environmentObject(globalContainer.resolve(SourcesRepository.self)!)
        }
    }
}

