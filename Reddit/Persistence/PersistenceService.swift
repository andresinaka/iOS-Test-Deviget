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

final class PersistenceService: PersistenceServiceProtocol {

    private static let readKey = "readKey"
    private static let hiddenKey = "hiddenKey"

    private let userDefaults: UserDefaultsServiceProtocol

    init(userDefaults: UserDefaultsServiceProtocol = UserDefaultsService()) {
        self.userDefaults = userDefaults
    }

    func setRead(redditPost: RedditPost?) {
        guard let redditPost = redditPost else { return }
        userDefaults.set(true, forKey: Self.readKey + redditPost.id)
    }

    func isRead(redditPost: RedditPost?) -> Bool {
        guard let redditPost = redditPost else { return false }
        return userDefaults.bool(forKey: Self.readKey + redditPost.id)
    }

    func setHidden(redditPost: RedditPost?) {
        guard let redditPost = redditPost else { return }
        userDefaults.set(true, forKey: Self.hiddenKey + redditPost.id)
    }

    func isHidden(redditPost: RedditPost?) -> Bool {
        guard let redditPost = redditPost else { return false }
        return userDefaults.bool(forKey: Self.hiddenKey + redditPost.id)
    }
}
