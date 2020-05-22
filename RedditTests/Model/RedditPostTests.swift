//
//  RedditPostTests.swift
//  RedditTests
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import XCTest
@testable import Reddit

class RedditPostTests: XCTestCase {

    func testFullObjectDecoder() throws {
        guard let data = FileHelpers.dataFromJSON(file: "RedditPostWithThumbnail") else { XCTFail(); return }
        let redditPost = try? JSONDecoder.reddit.decode(RedditPost.self, from: data)

        XCTAssertEqual(redditPost?.title, "Sticky bun for you!")
        XCTAssertEqual(redditPost?.author, "rnielsen776")
        XCTAssertEqual(redditPost?.createdUTC, Date(timeIntervalSince1970: 1590015768))
        XCTAssertEqual(redditPost?.numComments, 1365)
        XCTAssertEqual(redditPost?.postHint, RedditPost.PostHint.notSupported)
        XCTAssertEqual(redditPost?.thumbnailURL?.absoluteString, "https://b.thumbs.redditmedia.com/t9DyS4JczF4Jpv2IvIciWK9EOHCrSqiTEKc0y-iVoTw.jpg")
    }

    func testMissingDateDecoder() throws {
        guard let data = FileHelpers.dataFromJSON(file: "RedditPostNoThumbnail") else { XCTFail(); return }
        let redditPost = try? JSONDecoder.reddit.decode(RedditPost.self, from: data)
        
        XCTAssertEqual(redditPost?.title, "Sticky bun for you!")
        XCTAssertNil(redditPost?.thumbnailURL)
    }
}
