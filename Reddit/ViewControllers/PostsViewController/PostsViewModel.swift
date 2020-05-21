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
    var postCellViewModels: Observable<[PostCellViewModel]> { get }
    var title: Observable<String> { get }
}

final class PostsViewModel: PostsViewModelProtocol {
    var title = Observable("Reddit Posts")

    private var apiService: ApiServiceProtocol

    var postCellViewModels: Observable<[PostCellViewModel]> = Observable([])

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

    func fetchPosts() {
        apiService.execute(type: RedditTopResponse.self, request: Request.reddit(after: "", limit: 10)) { [weak self] result in
            switch result {
            case .success(let topResponse):
                guard let apiService = self?.apiService else { return }
                self?.postCellViewModels.value = topResponse?.posts.map { redditPost -> PostCellViewModel in
                    PostCellViewModel(apiService: apiService, post: redditPost)
                } ?? []
            case .failure(let error):
                print("FAILURE")
            }
        }
    }
}
