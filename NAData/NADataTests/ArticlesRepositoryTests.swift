//
//  ArticlesRepositoryTests.swift
//  NADataTests
//
//  Created by Rodrigo Brauwers on 06/12/23.
//

import Combine
import Foundation
import XCTest
@testable import NAData
@testable import NAModels
@testable import NANetwork

class NetworkDataSourceMock : NetworkDataSource {
    let sources: [Source]
    let articles: [Article]
    let shouldFail: Bool
    
    init(sources: [Source], articles: [Article], shouldFail: Bool) {
        self.sources = sources
        self.articles = articles
        self.shouldFail = shouldFail
    }
    
    func getSources() async throws -> [Source] {
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        if shouldFail {
            throw URLError(.badServerResponse)
        } else {
            return sources
        }
    }
    
    func getArticles() async throws -> [Article] {
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        if shouldFail {
            throw URLError(.badServerResponse)
        } else {
            return articles
        }
    }
        
}

class ArticlesRepositoryTests : XCTestCase {
    
    let sources: [Source] = [
        Source(id: "1", name: "", description: "", url: "", category: "", language: "", country: ""),
        Source(id: "2", name: "", description: "", url: "", category: "", language: "", country: "")
    ]
    
    let articles: [Article] = [
        Article(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "", content: ""),
        Article(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "", content: "")
    ]
    
    var correctNetworkDataSource: NetworkDataSource!
    var problematicNetworkDataSource: NetworkDataSource!
    var correctRepository: ArticlesRepository!
    var problematicRepository: ArticlesRepository!
    var cancellables = Set<AnyCancellable>()
    
    @MainActor
    override func setUpWithError() throws {
        correctNetworkDataSource = NetworkDataSourceMock(sources: sources, articles: articles, shouldFail: false)
        problematicNetworkDataSource = NetworkDataSourceMock(sources: sources, articles: articles, shouldFail: true)
        correctRepository = ArticlesRepository(networkDataSource: correctNetworkDataSource)
        problematicRepository = ArticlesRepository(networkDataSource: problematicNetworkDataSource)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor 
    func test_articlesShouldLoad() {
        let expectation = XCTestExpectation(description: "Data should load after few seconds")
        var count = 0
        
        correctRepository.$articles
            .dropFirst()
            .sink { items in
                count = items.count
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        Task {
            await correctRepository.load()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(count, articles.count)
    }
    
    @MainActor
    func test_articlesShouldFail() {
        let expectation = XCTestExpectation(description: "Data load should fail")
        var error: Error?
        
        problematicRepository.$error
            .dropFirst(2)
            .sink { e in
                error = e
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        Task {
            await problematicRepository.load()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual((error as? URLError)?.code, URLError.badServerResponse)
    }
    
}
