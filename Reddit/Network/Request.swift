//
//  Request.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var urlRequest: URLRequest? { get }
}

enum Request: RequestProtocol {

    case reddit(after: String = "", limit: Int)

    var urlRequest: URLRequest? {
        switch self {
        case .reddit(let after, let limit):
            guard let url = URL(string: "https://api.reddit.com/top?limit=\(limit)&after=\(after)") else { return nil }
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
    }
}
