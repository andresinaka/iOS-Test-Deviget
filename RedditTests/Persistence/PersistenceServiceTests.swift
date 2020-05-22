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

    var persistanceService: PersistenceService!
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
        persistanceService = PersistenceService(userDefaults: UserDefaultsServiceMock())
    }

    func testHidden() throws {
        XCTAssertFalse(persistanceService.isHidden(redditPost: reddintPost))
        persistanceService.setHidden(redditPost: reddintPost)
        XCTAssertTrue(persistanceService.isHidden(redditPost: reddintPost))
    }

    func testRead() throws {
        XCTAssertFalse(persistanceService.isRead(redditPost: reddintPost))
        persistanceService.setRead(redditPost: reddintPost)
        XCTAssertTrue(persistanceService.isRead(redditPost: reddintPost))
    }
}
