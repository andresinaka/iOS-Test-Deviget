//
//  PersistenceServiceMock.swift
//  RedditTests
//
//  Created by Andres Canal on 22/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
@testable import Reddit

final class PersistenceServiceMock: PersistenceServiceProtocol {

    var isRead: Bool = false
    var isHidden: Bool = false

    func setRead(redditPost: RedditPost?) {
    }

    func isRead(redditPost: RedditPost?) -> Bool {
        return isRead
    }

    func setHidden(redditPost: RedditPost?) {
    }

    func isHidden(redditPost: RedditPost?) -> Bool {
        return isHidden
    }
}
