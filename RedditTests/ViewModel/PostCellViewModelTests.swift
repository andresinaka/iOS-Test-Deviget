//
//  PostCellViewModelTests.swift
//  RedditTests
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import XCTest
@testable import Reddit

class PostCellViewModelTests: XCTestCase {

    func testPostWithImage() throws {

        let fixedDate = Date(timeIntervalSince1970: 1590015768)
        let redditPost = RedditPost(
            title: "Title",
            author: "Author",
            createdUTC: Date(timeInterval: 100, since: fixedDate),
            numComments: 140,
            thumbnailURL: URL(string: "https://b.thumbs.redditmedia.com/51ieejrpqfL6mEpt2NLFPkUXN_mQcqsYVZkLADytL6Q.jpg")
        )

        let postCellViewModel = PostCellViewModel(apiService: ApiServiceMock(), post: redditPost)
        XCTAssertEqual(postCellViewModel.title.value, "Title")
        XCTAssertEqual(postCellViewModel.authorName.value, "Author")
        XCTAssertEqual(postCellViewModel.commentsText.value, "140 Comments")
        XCTAssertEqual(postCellViewModel.dismissButtonTitle.value, "Dismiss Post")
        XCTAssertEqual(postCellViewModel.timeAgo.value, redditPost.createdUTC.timeAgoDisplay())
        XCTAssertTrue(postCellViewModel.showThumbnail.value)
    }
}
