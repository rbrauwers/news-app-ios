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

public struct ArticlesView : View {
    public init() {}
    
    public var body: some View {
        if #available(iOS 14, *) {
            ArticlesViewContent()
        } else {
            ArticlesViewLegacyContent()
        }
    }
    
}

@available(iOS 14, *)
struct ArticlesViewContent : View {
    @StateObject var repository = ArticlesRepository.shared
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack(alignment: .center) {
            if let error = repository.error {
                Text(error.localizedDescription)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Color.red)
                    .foregroundColor(.white)
            }
            
            Text("Hello, \(appState.user.name)")
            
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
            
            if repository.isLoading {
                ProgressView()
            }
            
            ArticlesList(articles: repository.articles.compactMap {
                ArticleUI(article: $0)
            })
        }
    }
    
}

struct ArticlesViewLegacyContent : View {

    var body: some View {
        Text("ArticlesViewLegacyContent")
    }
    
}

struct ArticlesList : View {
    
    let articles: [ArticleUI]
    
    var body: some View {
        List(articles) {
            ArticleItem(article: $0)
        }
        .listStyle(.plain)
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

struct ArticleItem : View {
    
    let article: ArticleUI
    
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
                    Image(systemName: "heart")
                        .tint(Color.accentColor)
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
}
