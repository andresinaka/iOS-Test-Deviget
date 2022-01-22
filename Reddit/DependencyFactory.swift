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
    let persistence = PersistenceService()

    // Not the biggest fan of having singletons but for the size and type of app this is ok.
    static let shared = DependencyFactory()

    private init() { }

    func postsViewModel() -> PostsViewModel {
        PostsViewModel(apiService: apiService, persistenceService: persistence)
    }

    func postDetailViewModel(post: RedditPost) -> PostDetailViewModel {
        PostDetailViewModel(post: post)
    }

    func postCellViewModel(post: RedditPost) -> PostCellViewModel {
        PostCellViewModel(apiService: apiService, persistenceService: persistence, post: post)
    }
}
