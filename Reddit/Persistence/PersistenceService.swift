//
//  PersistenceService.swift
//  Reddit
//
//  Created by Andres Canal on 22/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

protocol PersistenceServiceProtocol {

    func setRead(redditPost: RedditPost?)
    func isRead(redditPost: RedditPost?) -> Bool
    func setHidden(redditPost: RedditPost?)
    func isHidden(redditPost: RedditPost?) -> Bool
}

final class PersistanceService: PersistenceServiceProtocol {

    private let userDefaults = UserDefaults()

    func setRead(redditPost: RedditPost?) {
        guard let redditPost = redditPost else { return }
        userDefaults.set(true, forKey: redditPost.i)
    }

    func isRead(redditPost: RedditPost?) -> Bool {

    }

    func setHidden(redditPost: RedditPost?) {

    }

    func isHidden(redditPost: RedditPost?) -> Bool {

    }
}
