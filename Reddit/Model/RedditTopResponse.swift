//
//  RedditTopResponse.swift
//  Reddit
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

struct RedditTopResponse {
    var posts: [RedditPost]
}

extension RedditTopResponse: Decodable {

    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainContainerCodingKeys.self)

        let data = try mainContainer.nestedContainer(keyedBy: DataContainerCodingKeys.self, forKey: .data)
        posts = try data.decode([RedditPost].self, forKey: .children)
    }

    enum MainContainerCodingKeys: String, CodingKey {
        case after
        case posts
        case data
        case children
    }

    enum DataContainerCodingKeys: String, CodingKey {
        case children
    }
}
