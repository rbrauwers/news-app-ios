//
//  ArticlesView.swift
//  NAHeadlines
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import SwiftUI
import NAData
import NAModels
import NANetwork

public struct ArticlesView : View {
    @EnvironmentObject private var articlesRepository: ArticlesRepository
    
    public init() {
        
    }
    
    public var body: some View {
        if #available(iOS 14, *) {
            ArticlesViewContent()
                .environmentObject(
                    ArticlesViewModel(repository: articlesRepository)
                )
        } else {
            ArticlesViewLegacyContent()
        }
    }
    
}

@available(iOS 14, *)
struct ArticlesViewContent : View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var viewModel: ArticlesViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                if let error = viewModel.repository.error {
                    Text(error.localizedDescription)
                        .padding(10)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                }
                
                Text("Someone")
                
                Text("Hello, \(appState.user.name)")
                    .accessibilityIdentifier("username")
                
                /*
                NavigationLink(destination: InfoView()) {
                    if #available(iOS 16, *) {
                        // Without this toolbar stuff the tab doesn't obey correct insets
                        // Maybe this solution works
                        // https://stackoverflow.com/questions/69165132/swift-ui-clicking-navigation-bar-link-hides-status-bar-on-back
                        Text("Click me").toolbar(.hidden, for: .bottomBar)
                    }
                }
                .buttonStyle(.plain)
                 */
                
                if viewModel.repository.isLoading {
                    ProgressView()
                }
                
                ArticlesList(
                    articles: viewModel.repository.articles.compactMap {
                        ArticleUI(article: $0)
                    }
                )
            }
            
            Image(systemName: "heart")
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
                .opacity(viewModel.liking ? 1.0 : 0.0)
                .animation(.easeInOut, value: viewModel.liking)
        }
    }
    
}

struct ArticlesViewLegacyContent : View {

    var body: some View {
        Text("ArticlesViewLegacyContent")
    }
    
}

@available(iOS 14, *)
private struct ArticlesList : View {
    
    let articles: [ArticleUI]
    @EnvironmentObject private var viewModel: ArticlesViewModel
    
    var body: some View {
        List(articles) {
            ArticleItem(article: $0)
        }
        .listStyle(.plain)
        .accessibilityIdentifier("articlesList")
    }
    
}

private extension View {
    
    func hiddenListRowSeparator() -> some View {
        if #available(iOS 15.0, *) {
            return self.listRowSeparator(.hidden)
        } else {
            return self
        }
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
                        .background(Color.white)
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
                
                if #available(iOS 16.0, *) {
                    Button {
                        viewModel.like(article: article)
                    } label: {
                        let isLiked = viewModel.isLiked(article: article)
                        
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .accessibilityLabel(isLiked ? "liked" : "notLiked")
                    }
                    .tint(Color.accentColor)
                    .buttonStyle(ScaleButtonStyle())
                    .accessibilityIdentifier("likeButton")
                    
                } else {
                    Image(systemName: "heart")
                }
            }
        }
        .frame(height: 120)
        .hiddenListRowSeparator()
        .padding()
        .background(Color(red: 0.93, green: 0.9, blue: 0.96))
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

@available(iOS 14, *)
#Preview("Articles list2") {
    let article = ArticleUI(
        article: Article(
            author: "Bob Dylan",
            title: "Earthquake",
            description: "The description",
            url: "",
            urlToImage: "https://images.pexels.com/photos/3373744/pexels-photo-3373744.jpeg",
            publishedAt: "2023-11-26T01:44:52Z",
            content: "The content1 content2 content3 content4 content5 content6 content7 content8 content9 content10 content11 content12 content13 content14 content15 content16 content17")
        )

    let article2 = ArticleUI(
        article: Article(
            author: "John Smith",
            title: "Hurricante",
            description: "The description",
            url: "",
            urlToImage: "https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg",
            publishedAt: "2023-10-05T04:14:00Z",
            content: "The content1 content2 content3 content4 content5 content6 content7 content8 content9 content10 content11 content12 content13 content14 content15 content16 content17")
        )
    
    return ArticlesList(articles: [article, article2])
        .environmentObject(ArticlesViewModel(repository: ArticlesRepository(networkDataSource: DefaultNetworkDataSource())))
}

@MainActor
private class ArticlesViewModel : ObservableObject {
    @Published var liking: Bool = false
    @Published var likedArticles = [ArticleUI]()
    private var likingTask: Task<(),Error>? = nil
    
    // TODO: should be private
    public let repository: ArticlesRepository
        
    init(repository: ArticlesRepository) {
        self.repository = repository
    }
    
    func like(article: ArticleUI) {
        if isLiked(article: article) {
            likedArticles.removeAll(where: { $0 == article })
        } else {
            likedArticles.append(article)
        }
        
        likingTask?.cancel()
        liking = true
        
        likingTask = Task {
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            liking = false
        }
    }
    
    func isLiked(article: ArticleUI) -> Bool {
        return likedArticles.contains(where: { $0 == article })
    }
}
