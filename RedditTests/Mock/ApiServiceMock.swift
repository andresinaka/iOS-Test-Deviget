//
//  File.swift
//  RedditTests
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit
@testable import Reddit

struct ApiServiceMock: ApiServiceProtocol {
    func execute<T>(type: T.Type, request: RequestProtocol, completion: @escaping (Result<T?, Error>) -> Void) -> URLSessionDataTask? where T : Decodable {
        return nil
    }

    func downloadImage(imageURL: URL?, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
        return nil
    }
}
