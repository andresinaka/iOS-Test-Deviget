//
//  PersistenceServiceTests.swift
//  RedditTests
//
//  Created by Andres Canal on 22/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import XCTest
@testable import Reddit

class PersistenceServiceTests: XCTestCase {

    var persistenceService: PersistenceService!
    let reddintPost = RedditPost(
        id: "a-key",
        title: "title",
        author: "author",
        createdUTC: Date(),
        numComments: 0,
        thumbnailURL: nil,
        url: nil,
        postHint: .image
    )

    override func setUpWithError() throws {
        persistenceService = PersistenceService(userDefaults: UserDefaultsServiceMock())
    }

    func testHidden() throws {
        XCTAssertFalse(persistenceService.isHidden(redditPost: reddintPost))
        persistenceService.setHidden(redditPost: reddintPost)
        XCTAssertTrue(persistenceService.isHidden(redditPost: reddintPost))
    }

    func testRead() throws {
        XCTAssertFalse(persistenceService.isRead(redditPost: reddintPost))
        persistenceService.setRead(redditPost: reddintPost)
        XCTAssertTrue(persistenceService.isRead(redditPost: reddintPost))
    }
}
