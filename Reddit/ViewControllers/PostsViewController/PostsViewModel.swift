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
    var alert: Observable<UIAlertController?> { get }
    var isFetching: Observable<Bool> { get }

    var title: String { get }
    var dismissAllButtonTitle: String { get }

    func fetchFirstPage()
    func dismissAll()
    func dismissPost(postCellViewModel: PostCellViewModel)
}

final class PostsViewModel: PostsViewModelProtocol {

    static let postsPerPage = 10

    let title = "Reddit Posts"
    let dismissAllButtonTitle = "Dismiss All"

    private var apiService: ApiServiceProtocol
    private var persistanceService: PersistenceServiceProtocol
    private var allPosts: [RedditPost] = []

    let dataSnapshot: Observable<NSDiffableDataSourceSnapshot<Int, PostCellViewModel>?> = Observable(nil)
    let dismissAllButtonEnabled: Observable<Bool> = Observable(false)
    let alert: Observable<UIAlertController?> = Observable(nil)
    var isFetching: Observable<Bool> = Observable(false)

    init(apiService: ApiServiceProtocol, persistanceService: PersistenceServiceProtocol) {
        self.apiService = apiService
        self.persistanceService = persistanceService
    }

    func fetchFirstPage() {
        apiService.execute(type: RedditTopResponse.self, request: Request.reddit(after: "", limit: Self.postsPerPage)) { [weak self] result in
            self?.isFetching.value = false
            switch result {
            case .success(let topResponse):
                self?.refresh(posts: topResponse?.posts ?? [])
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.alert.value = UIAlertController.alertWith(title: "Error", message: "Something went wrong", buttonTitle: "Ok")
                }
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

    func refresh(posts: [RedditPost]) {
        defer { allPosts += posts }

        let newPosts = posts.filter { [weak self] newPost -> Bool in
            self?.allPosts.first { $0.id == newPost.id } == nil
        }

        let newPostCellViewModels = createPostCellViewModels(from: newPosts)

        guard var snapshot = dataSnapshot.value else {
            var snapshot = NSDiffableDataSourceSnapshot<Int, PostCellViewModel>()
            snapshot.appendSections([0])
            snapshot.appendItems(newPostCellViewModels)
            dataSnapshot.value = snapshot

            return
        }

        if let firstItemIdentifier = snapshot.itemIdentifiers.first {
            snapshot.insertItems(newPostCellViewModels, beforeItem: firstItemIdentifier)
        } else {
            snapshot.appendItems(newPostCellViewModels)
        }

        dataSnapshot.value = snapshot
    }

    func createPostCellViewModels(from posts: [RedditPost]) -> [PostCellViewModel] {
        return posts.map { redditPost -> PostCellViewModel in
            PostCellViewModel(apiService: apiService, persistanceService: persistanceService, post: redditPost)
        }.filter { [weak self] postCellViewModel -> Bool in
            self?.persistanceService.isHidden(redditPost: postCellViewModel.post) == false
        }
    }
}
