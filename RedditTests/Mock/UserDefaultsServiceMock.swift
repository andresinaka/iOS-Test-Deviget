//
//  UserDefaultsServiceMock.swift
//  RedditTests
//
//  Created by Andres Canal on 22/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
@testable import Reddit

final class UserDefaultsServiceMock: UserDefaultsServiceProtocol {

    private var userDefaults: [String: Bool] = [:]

    func set(_ value: Bool, forKey defaultName: String) {
        userDefaults[defaultName] = value
    }

    func bool(forKey defaultName: String) -> Bool {
        return userDefaults[defaultName] ?? false
    }
}
