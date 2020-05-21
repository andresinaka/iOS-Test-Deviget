//
//  ApiService.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit

protocol ApiServiceProtocol {
    @discardableResult
    func execute<T: Decodable>(type: T.Type, request: RequestProtocol, completion: @escaping (Result<T?, Error>) -> Void) -> URLSessionDataTask?

    @discardableResult
    func downloadImage(imageURL: URL?, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask?
}

struct ApiService: ApiServiceProtocol {

    let session: URLSession

    init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
    }

    @discardableResult
    func execute<T: Decodable>(type: T.Type, request: RequestProtocol, completion: @escaping (Result<T?, Error>) -> Void) -> URLSessionDataTask? {
        guard let urlRequest = request.urlRequest else {
            completion(Result.failure(AppError.generic("Missing urlRequest")))
            return nil
        }

        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in

            let completeOnMainThread: (Result<T?, Error>) -> Void = { (result: Result) in
                DispatchQueue.main.async { completion(result) }
            }

            if let error = error as? URLError {
                completeOnMainThread(Result.failure(AppError.url(error)))
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard statusCode >= 200 && statusCode <= 299 else {
                completeOnMainThread(Result.failure(AppError.httpError(statusCode)))
                return
            }

            guard let data = data else {
                completeOnMainThread(Result.success(nil))
                return
            }

            do {
                let decoder = JSONDecoder.reddit
                let decodedObject = try decoder.decode(type, from: data)
                completeOnMainThread(Result.success(decodedObject))
            } catch {
                completeOnMainThread(Result.failure(AppError.parseError))
            }
        }

        dataTask.resume()
        return dataTask
    }

    @discardableResult
    func downloadImage(imageURL: URL?, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
        guard let imageURL = imageURL else {
            completion(Result.failure(AppError.generic("Missing url")))
            return nil
        }

        return session.dataTask(with: imageURL) { (data, urlResponse, error) in

            let completeOnMainThread: (Result<UIImage, Error>) -> Void = { (result: Result) in
                DispatchQueue.main.async { completion(result) }
            }

            guard let data = data, let image = UIImage(data: data) else {
                completeOnMainThread(.failure(AppError.generic("Failed to download Image")))
                return
            }

            completeOnMainThread(.success(image))
        }
    }
}
