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
    var authorFullname: String
    var createdUTC: Date
    var numComments: Int
    var thumbnailURL: URL?
}

extension RedditPost: Decodable {

    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainContainerCodingKeys.self)

        let data = try mainContainer.nestedContainer(keyedBy: DataContainerCodingKeys.self, forKey: .data)
        title = try data.decode(String.self, forKey: .title)
        authorFullname = try data.decode(String.self, forKey: .authorFullName)
        createdUTC = try data.decode(Date.self, forKey: .createdUTC)
        numComments = try data.decode(Int.self, forKey: .numComments)
        thumbnailURL = try? data.decode(URL.self, forKey: .thumbnail)
    }

    enum MainContainerCodingKeys: String, CodingKey {
        case data
    }

    enum DataContainerCodingKeys: String, CodingKey {
        case title
        case authorFullName = "author_fullname"
        case createdUTC = "created_utc"
        case numComments = "num_comments"
        case thumbnail
    }
}
