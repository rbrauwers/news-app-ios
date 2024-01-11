//
//  SettingsViewModel.swift
//  News
//
//  Created by Rodrigo Brauwers on 10/01/24.
//

import Foundation
import Combine
import SwiftUI
import NAData
import NAModels

class SettingsViewModel : ObservableObject {
    
    @Published public private(set) var uiState: SettingsUiState = SettingsUiState(likedArticles: nil)
    
    private let repository: ArticlesRepository
    private var cancellable: AnyCancellable?
    
    public init(repository: ArticlesRepository) {
        self.repository = repository
        observeRepository()
    }
    
    private func observeRepository() {
        cancellable = repository
            .dataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { data in
                guard case let ArticlesRepository.DATA.success(articles) = data else {
                    return
                }
                
                self.uiState = SettingsUiState(likedArticles: articles
                    .filter { $0.liked }
                    .map { $0.toLikedArticleUi() }
                )
            })
    }
    
    public func removeLikes(from articles: [LikedArticleUi]) {
        guard #available(iOS 15.0, *) else { return }
            
        let likes = Dictionary(uniqueKeysWithValues: articles
            .filter { $0.isSelected }
            .map { ($0.id, false) }
        )
        
        Task {
            await repository.updateLikes(likes)
        }
    }
    
}

struct LikedArticleUi {
    let id: Int
    let title: String
    var isSelected: Bool
}

struct SettingsUiState {
    let likedArticles: [LikedArticleUi]?
    
    var likedArticlesCount: String {
        if let articles = likedArticles {
            String(articles.count)
        } else {
            "N/A"
        }
    }
}

private extension Article {
    
    func toLikedArticleUi() -> LikedArticleUi {
        return LikedArticleUi(id: self.id, title: self.title ?? "N/A", isSelected: false)
    }
    
}
