//
//  PostsViewModel.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit

protocol PostsViewModelProtocol {

    var dataSnapshot: Observable<NSDiffableDataSourceSnapshot<Int, PostCellViewModel>?> { get }
    var dismissAllButtonEnabled: Observable<Bool> { get }
    var title: String { get }
    var dismissAllButtonTitle: String { get }

    func fetchPosts()
    func dismissAll()
    func dismissPost(postCellViewModel: PostCellViewModel)
}

final class PostsViewModel: PostsViewModelProtocol {

    let title = "Reddit Posts"
    let dismissAllButtonTitle = "Dismiss All"

    private var apiService: ApiServiceProtocol
    private var persistanceService: PersistenceServiceProtocol

    let dataSnapshot: Observable<NSDiffableDataSourceSnapshot<Int, PostCellViewModel>?> = Observable(nil)
    let dismissAllButtonEnabled: Observable<Bool> = Observable(false)

    init(apiService: ApiServiceProtocol, persistanceService: PersistenceServiceProtocol) {
        self.apiService = apiService
        self.persistanceService = persistanceService
    }

    func fetchPosts() {
        apiService.execute(type: RedditTopResponse.self, request: Request.reddit(after: "", limit: 10)) { [weak self] result in
            switch result {
            case .success(let topResponse):
                self?.appendPosts(posts: topResponse?.posts ?? [])
            case .failure(let error):
                print("FAILURE")
            }
        }
    }

    func dismissPost(postCellViewModel: PostCellViewModel) {
        persistanceService.setHidden(redditPost: postCellViewModel.post)
        hidePosts(postCellViewModels: [postCellViewModel])
    }

    func dismissAll() {
        let viewModels = dataSnapshot.value?.itemIdentifiers(inSection: 0) ?? []
        for viewModel in viewModels {
            persistanceService.setHidden(redditPost: viewModel.post)
        }
        hidePosts(postCellViewModels: viewModels)
    }
}

private extension PostsViewModel {

    func hidePosts(postCellViewModels: [PostCellViewModel]) {
        guard var snapshot = dataSnapshot.value else { return }
        snapshot.deleteItems(postCellViewModels)
        dataSnapshot.value = snapshot
        dismissAllButtonEnabled.value = snapshot.numberOfItems != 0
    }

    func appendPosts(posts: [RedditPost]) {
        let postCellViewModels = posts.map { redditPost -> PostCellViewModel in
            PostCellViewModel(apiService: apiService, persistanceService: persistanceService, post: redditPost)
        }.filter { [weak self] postCellViewModel -> Bool in
            self?.persistanceService.isHidden(redditPost: postCellViewModel.post) == false
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, PostCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(postCellViewModels)
        dataSnapshot.value = snapshot

        dismissAllButtonEnabled.value = postCellViewModels.count > 0
    }
}
