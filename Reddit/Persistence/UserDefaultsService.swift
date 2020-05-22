//
//  UserDefaultsService.swift
//  Reddit
//
//  Created by Andres Canal on 22/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

protocol UserDefaultsServiceProtocol {

    func set(_ value: Bool, forKey defaultName: String)
    func bool(forKey defaultName: String) -> Bool
}

final class UserDefaultsService: UserDefaultsServiceProtocol {

    private let userDefaults = UserDefaults()

    func set(_ value: Bool, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }

    func bool(forKey defaultName: String) -> Bool {
        userDefaults.bool(forKey: defaultName)
    }
}
