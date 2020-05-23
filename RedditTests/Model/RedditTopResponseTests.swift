//
//  RedditTopResponseTests.swift
//  RedditTests
//
//  Created by Andres Canal on 23/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import XCTest
@testable import Reddit

class RedditTopResponseTests: XCTestCase {

    func testObjectDecoder() throws {
        guard let data = FileHelpers.dataFromJSON(file: "RedditTopResponse") else { XCTFail(); return }
        let redditPost = try? JSONDecoder.reddit.decode(RedditTopResponse.self, from: data)

        XCTAssertEqual(redditPost?.after, "t3_gorshc")
        XCTAssertEqual(redditPost?.posts.count, 2)
    }

}
