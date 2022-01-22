//
//  PostDetailViewModelTests.swift
//  RedditTests
//
//  Created by Andres Canal on 22/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import XCTest
@testable import Reddit

class PostDetailViewModelTests: XCTestCase {

    func testPostWithImage() throws {
        let redditPost = RedditPost(
            id: "some-id",
            title: "Title",
            author: "Author",
            createdUTC: Date(),
            numComments: 140,
            thumbnailURL: URL(string: "https://b.thumbs.redditmedia.com/51ieejrpqfL6mEpt2NLFPkUXN_mQcqsYVZkLADytL6Q.jpg"),
            postHint: .image
        )

        let postCellViewModel = PostDetailViewModel(post: redditPost)
        XCTAssertEqual(postCellViewModel.title, "Title")
        XCTAssertEqual(postCellViewModel.authorName, "Author")
        XCTAssertEqual(postCellViewModel.mediaNotSupportedText, "No images available")
        XCTAssertTrue(postCellViewModel.showMedia)

    }

    func testPostWithNoImage() throws {
        let redditPost = RedditPost(
            id: "some-id",
            title: "Title",
            author: "Author",
            createdUTC: Date(),
            numComments: 140,
            thumbnailURL: nil,
            postHint: .notSupported
        )

        let postCellViewModel = PostDetailViewModel(post: redditPost)
        XCTAssertEqual(postCellViewModel.title, "Title")
        XCTAssertEqual(postCellViewModel.authorName, "Author")
        XCTAssertFalse(postCellViewModel.showMedia)
    }

}
