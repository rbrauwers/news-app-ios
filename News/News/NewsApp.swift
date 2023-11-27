//
//  NewsApp.swift
//  News
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import SwiftUI
import NAData

@main
struct WeatherProAppWrapper {
    static func main() {
        Task {
            await SourcesRepository.shared.load()
            await ArticlesRepository.shared.load()
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
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
