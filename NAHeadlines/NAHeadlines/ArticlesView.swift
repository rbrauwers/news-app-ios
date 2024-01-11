//
//  ArticlesView.swift
//  NAHeadlines
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import Combine
import SwiftUI
import Swinject
import NACommon
import NAData
import NAModels
import NANetwork

public struct ArticlesView : View {

    public init() {
        
    }
    
    public var body: some View {
        ArticlesViewContent()
            .environmentObject(
                globalContainer.resolve(ArticlesViewModel.self)!
            )
    }
    
}

struct ArticlesViewContent : View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var viewModel: ArticlesViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                switch viewModel.uiState {
                case .loading:
                    if #available(iOS 14.0, *) {
                        ProgressView()
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                        .padding(10)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                case .success(let articles):
                    HStack(spacing: 8) {
                        Text("Hello, \(appState.user.name)")
                            .backport
                            .accessibilityIdentifier("username")
                        
                        Image(.test)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                    ArticlesList(articles: articles)
                }
            }
            
            /*
            Image(systemName: "heart")
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
                .opacity(viewModel.liking ? 1.0 : 0.0)
                .animation(.easeInOut, value: viewModel.liking)
             */
        }
    }
    
}

private struct ArticlesList : View {
    
    let articles: [ArticleUI]
    @State private var searchTerm = ""
    
    private var filteredArticles: [ArticleUI] {
        if searchTerm.isEmpty {
            return articles
        } else {
            return articles.filter { article in
                article.content.localizedCaseInsensitiveContains(searchTerm) ||
                article.author.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    @EnvironmentObject private var viewModel: ArticlesViewModel
    
    var body: some View {
        List(filteredArticles, id: \.id) {
            ArticleItem(article: $0)
        }
        .backport.contentUnavailable(condition: filteredArticles.isEmpty && !searchTerm.isEmpty, text: searchTerm)
        .listStyle(.plain)
        .backport.accessibilityIdentifier("articlesList")
        .backport.searchable(text: $searchTerm, prompt: "Search articles")
    }
    
}

private struct ArticleItem : View {
    
    let article: ArticleUI
    @EnvironmentObject private var viewModel: ArticlesViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(article.author).font(.headline)
                
                Spacer()
                
                Text(article.content)
                    .font(.subheadline)
                    .lineLimit(3)
                
                Spacer()
                
                if let publishedAt = article.publishedAt {
                    Text(publishedAt)
                        .font(.caption)
                        .padding(EdgeInsets(top: 4.0, leading: 8.0, bottom: 4.0, trailing: 8.0))
                        .background(Color._onSecondaryContainer)
                        .foregroundColor(Color.black)
                        .cornerRadius(5.0)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if let url = article.urlToImage, #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: url)) { image in
                        image.image?.resizable().scaledToFill()
                    }
                    .frame(width: 70, height: 70, alignment: .center)
                    .cornerRadius(10.0)
                } else {
                    // TODO
                }
                
                Spacer()
                
                Button {
                    viewModel.toggleLiked(article: article)
                } label: {
                    Image(systemName: article.liked ? "heart.fill" : "heart")
                        .backport.accessibilityLabel(article.liked ? "liked" : "notLiked")
                }
                .foregroundColor(Color._accent)
                .buttonStyle(ScaleButtonStyle())
                .backport.accessibilityIdentifier("likeButton")
            }
        }
        .frame(height: 120)
        .backport
        .hiddenListRowSeparator()
        .padding()
        .background(Color._primaryContainer)
        .cornerRadius(10.0)
    }
    
}

struct InfoView : View {
    
    var body: some View {
        Text("Info screen")
    }
    
}

private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 2 : 1)
    }
}

#Preview("Articles list2") {
    let article = ArticleUI(
        article: Article(
            author: "Bob Dylan",
            title: "Earthquake",
            description: "The description",
            url: "",
            urlToImage: "https://images.pexels.com/photos/3373744/pexels-photo-3373744.jpeg",
            publishedAt: "2023-11-26T01:44:52Z",
            content: "The content1 content2 content3 content4 content5 content6 content7 content8 content9 content10 content11 content12 content13 content14 content15 content16 content17",
            id: 1,
            liked: true)
        )

    let article2 = ArticleUI(
        article: Article(
            author: "John Smith",
            title: "Hurricante",
            description: "The description",
            url: "",
            urlToImage: "https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg",
            publishedAt: "2023-10-05T04:14:00Z",
            content: "The content1 content2 content3 content4 content5 content6 content7 content8 content9 content10 content11 content12 content13 content14 content15 content16 content17",
            id: 2,
            liked: false)
        )

    let container = Container()
        .registerNetworkDependencies(uiTesting: true)
        .registerDataDependencies()
    
    return ArticlesList(articles: [article, article2])
            //.environmentObject(ArticlesViewModel(repository: container.resolve(DefaultArticlesRepository.self)!))
}

class ArticlesViewModel : ObservableObject {
    
    @Published public private(set) var uiState: StatefulData<[ArticleUI]> = .loading
    
    private var cancellable: AnyCancellable?
    private let repository: ArticlesRepository
    
    init(repository: ArticlesRepository) {
        self.repository = repository
        observeRepository()
    }
    
    private func observeRepository() {
        cancellable = repository
            .dataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { data in
                self.uiState = data.map { articles in
                    articles.compactMap {
                        ArticleUI(article: $0)
                    }
                }
            })
    }
    
    @MainActor
    func toggleLiked(article: ArticleUI) {
        let _ = repository.updateLiked(articleId: article.id, liked: article.liked ? false : true)
    }
    
}
