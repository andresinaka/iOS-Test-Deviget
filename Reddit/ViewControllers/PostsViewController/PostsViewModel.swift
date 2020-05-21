//
//  PostsViewModel.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

protocol PostsViewModelProtocol {
    func fetchPosts()
    var posts: Observable<[RedditPost]> { get }
}

final class PostsViewModel: ObservableObject, PostsViewModelProtocol {

    private var apiService: ApiServiceProtocol

    var posts: Observable<[RedditPost]> = Observable([])

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

    func fetchPosts() {
        apiService.execute(type: RedditTopResponse.self, request: Request.reddit(after: "", limit: 10)) { [weak self] result in
            switch result {
            case .success(let topResponse):
                self?.posts.value = []
            case .failure(let error):
                print("FAILURE")
            }
        }
    }
}
