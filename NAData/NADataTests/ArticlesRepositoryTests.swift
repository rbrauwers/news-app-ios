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
@testable import TestUtils

class ArticlesRepositoryTests : XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor 
    func test_articlesShouldLoad() {
        let expectation = XCTestExpectation(description: "Data should load after few seconds")
        var count = 0
        
        stableArticlesRepository.$articles
            .dropFirst()
            .sink { items in
                count = items.count
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        Task {
            await stableArticlesRepository.load()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(count, NetworkDataSourceMock.articles.count)
    }
    
    @MainActor
    func test_articlesShouldFail() {
        let expectation = XCTestExpectation(description: "Data load should fail")
        var error: Error?
        
        unstableArticlesRepository.$error
            .dropFirst(2)
            .sink { e in
                error = e
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        Task {
            await unstableArticlesRepository.load()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual((error as? URLError)?.code, URLError.badServerResponse)
    }
    
}
