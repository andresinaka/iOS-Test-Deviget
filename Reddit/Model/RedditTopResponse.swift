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
    var after: String?
}

extension RedditTopResponse: Decodable {

    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainContainerCodingKeys.self)

        let data = try mainContainer.nestedContainer(keyedBy: DataContainerCodingKeys.self, forKey: .data)
        posts = try data.decode([RedditPost].self, forKey: .children)
        after = try? data.decode(String.self, forKey: .after)
    }

    enum MainContainerCodingKeys: String, CodingKey {
        case data
    }

    enum DataContainerCodingKeys: String, CodingKey {
        case children
        case after
    }
}
