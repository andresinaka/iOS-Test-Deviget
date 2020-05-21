//
//  FileHelpers.swift
//  RedditTests
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

final class FileHelpers {

    static func dataFromJSON(file: String) -> Data? {
        guard
            let filePath = Bundle(for: FileHelpers.self).path(forResource: file, ofType: "json"),
            let content = try? String(contentsOfFile: filePath) else {
                return nil
            }

        return Data(content.utf8)
    }
}
