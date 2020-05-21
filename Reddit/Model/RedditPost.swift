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
    var author: String
    var createdUTC: Date
    var numComments: Int
    var thumbnailURL: URL?
}

extension RedditPost: Decodable {

    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainContainerCodingKeys.self)

        let data = try mainContainer.nestedContainer(keyedBy: DataContainerCodingKeys.self, forKey: .data)
        title = try data.decode(String.self, forKey: .title)
        author = try data.decode(String.self, forKey: .author)
        createdUTC = try data.decode(Date.self, forKey: .createdUTC)
        numComments = try data.decode(Int.self, forKey: .numComments)
        thumbnailURL = try? data.decode(URL.self, forKey: .thumbnail)

        if thumbnailURL?.scheme == nil {
            thumbnailURL = nil
        }
    }

    enum MainContainerCodingKeys: String, CodingKey {
        case data
    }

    enum DataContainerCodingKeys: String, CodingKey {
        case title
        case author = "author"
        case createdUTC = "created_utc"
        case numComments = "num_comments"
        case thumbnail
    }
}
