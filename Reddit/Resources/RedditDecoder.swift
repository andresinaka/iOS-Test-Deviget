//
//  RedditDecoder.swift
//  Reddit
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var reddit: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
}
