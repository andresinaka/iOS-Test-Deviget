//
//  RedditPost.swift
//  Reddit
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

struct RedditPost: Hashable {
    var id: String
    var title: String
    var author: String
    var createdUTC: Date
    var numComments: Int
    var thumbnailURL: URL?
    var url: URL?
    var postHint: PostHint

    enum PostHint: String, Decodable {
        case image
        case notSupported
    }
}

extension RedditPost: Decodable {

    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainContainerCodingKeys.self)

        let data = try mainContainer.nestedContainer(keyedBy: DataContainerCodingKeys.self, forKey: .data)
        id = try data.decode(String.self, forKey: .id)
        title = try data.decode(String.self, forKey: .title)
        author = try data.decode(String.self, forKey: .author)
        createdUTC = try data.decode(Date.self, forKey: .createdUTC)
        numComments = try data.decode(Int.self, forKey: .numComments)
        thumbnailURL = try? data.decode(URL.self, forKey: .thumbnail)
        url = try? data.decode(URL.self, forKey: .url)
        postHint = (try? data.decode(PostHint.self, forKey: .postHint)) ?? .notSupported

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
        case url
        case postHint = "post_hint"
        case id
    }
}
