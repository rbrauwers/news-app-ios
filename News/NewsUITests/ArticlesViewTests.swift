//
//  ArticlesViewTests.swift
//  NewsUITests
//
//  Created by Rodrigo Brauwers on 07/12/23.
//

import Combine
import XCTest
@testable import TestUtils

final class ArticlesViewTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["-UITesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func test_usernameShouldBeDisplayed() {
        let usernameText = app.staticTexts["username"]
        XCTAssertTrue(usernameText.label.contains("Rodrigo"))
    }
    
    func test_likedArticleShouldHaveFilledHeart() {
        let articlesList = app.collectionViews["articlesList"]
        let likeButton = articlesList.cells.firstMatch.buttons["likeButton"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 10))
        
        likeButton.tap()
        
        //debugPrint(app.debugDescription)
        
        XCTAssertTrue(likeButton.label == "liked")
    }
     
    /// To debug view herarchy, set a breakpoint with command: *po app*
    /// https://developer.apple.com/forums/thread/9045
    func test_dislikedArticleShouldHaveDefaultHeart() {
        let articlesList = app.collectionViews["articlesList"]
        let likeButton = articlesList.cells.firstMatch.buttons["likeButton"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 10))
        
        likeButton.tap()
        likeButton.tap()
        
        //debugPrint(app.debugDescription)
        
        XCTAssertTrue(likeButton.label == "notLiked")
    }
    
}
