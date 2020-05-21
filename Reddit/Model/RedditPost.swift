//
//  RedditPost.swift
//  Reddit
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

struct RedditPost {
    var title: String
}

extension RedditPost: Decodable {

    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainContainerCodingKeys.self)

        let data = try mainContainer.nestedContainer(keyedBy: DataContainerCodingKeys.self, forKey: .data)
        title = try data.decode(String.self, forKey: .title)
    }

    enum MainContainerCodingKeys: String, CodingKey {
        case data
    }

    enum DataContainerCodingKeys: String, CodingKey {
        case title
    }
}
