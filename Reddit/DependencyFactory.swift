//
//  DependencyFactory.swift
//  Reddit
//
//  Created by Andres Canal on 23/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation

final class DependencyFactory {

    let apiService = ApiService()
    let persistance = PersistenceService()

    // Not the biggest fan of having singletons but for the size and type of app this is ok.
    static let shared = DependencyFactory()

    private init() { }

    func postsViewModel() -> PostsViewModel {
        PostsViewModel(apiService: self.apiService, persistanceService: self.persistance)
    }

    func postDetailViewModel(post: RedditPost) -> PostDetailViewModel {
        PostDetailViewModel(apiService: self.apiService, post: post)
    }

    func postCellViewModel(post: RedditPost) -> PostCellViewModel {
        PostCellViewModel(apiService: self.apiService, persistanceService: self.persistance, post: post)
    }
}
