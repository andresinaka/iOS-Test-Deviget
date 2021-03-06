//
//  PostsViewModel.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit
import os.log

protocol PostsViewModelProtocol {

    var dataSnapshot: Observable<NSDiffableDataSourceSnapshot<Int, PostCellViewModel>?> { get }
    var dismissAllButtonEnabled: Observable<Bool> { get }
    var alert: Observable<UIAlertController?> { get }
    var isPullingToRefresh: Observable<Bool> { get }
    var isLoadingMore: Observable<Bool> { get }
    var showEmptyListMessage: Observable<Bool> { get }
    var isFetching: Bool { get }

    var title: String { get }
    var dismissAllButtonTitle: String { get }
    var emptyListMessage: String { get }

    func fetchFirstPage()
    func fetchNextPage()
    func dismissAll()
    func dismissPost(postCellViewModel: PostCellViewModel)
}

final class PostsViewModel: PostsViewModelProtocol {

    static let postsPerPage = 20

    let title = "Reddit Posts"
    let dismissAllButtonTitle = "Dismiss All"
    let emptyListMessage = "No new posts! \nPull to refresh!"

    private var apiService: ApiServiceProtocol
    private var persistanceService: PersistenceServiceProtocol
    private var allPosts: [RedditPost] = []
    private var nextPageAfter: String?
    private(set) var isFetching: Bool = false

    let dataSnapshot: Observable<NSDiffableDataSourceSnapshot<Int, PostCellViewModel>?> = Observable(nil)
    let dismissAllButtonEnabled: Observable<Bool> = Observable(false)
    let alert: Observable<UIAlertController?> = Observable(nil)
    let isPullingToRefresh: Observable<Bool> = Observable(false)
    let showEmptyListMessage: Observable<Bool> = Observable(false)
    let isLoadingMore: Observable<Bool> = Observable(true)

    init(apiService: ApiServiceProtocol, persistanceService: PersistenceServiceProtocol) {
        self.apiService = apiService
        self.persistanceService = persistanceService
    }

    func fetchFirstPage() {
        fetchPosts(after: nil)
    }

    func fetchNextPage() {
        isLoadingMore.value = true
        fetchPosts(after: nextPageAfter)
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

    func fetchPosts(after: String?) {
        guard !isFetching else { return }
        isFetching = true
        os_log("Fetching posts after: %@", log: OSLog.viewModel, type: .info, after ?? "--")

        let request = Request.reddit(after: after ?? "", limit: Self.postsPerPage)
        apiService.execute(type: RedditTopResponse.self, request: request) { [weak self] result in
            self?.isPullingToRefresh.value = false
            switch result {
            case .success(let topResponse):
                if after != nil || self?.nextPageAfter == nil {
                    self?.nextPageAfter = topResponse?.after
                }

                self?.updateSnapshot(posts: topResponse?.posts ?? [], append: after != nil)
                os_log("Returned posts: %d", log: OSLog.viewModel, type: .info, topResponse?.posts.count ?? 0)
            case .failure(let error):
                self?.createRequestErrorAlert()
                os_log("Fetching posts failed: %@ ", log: OSLog.viewModel, type: .info, error.localizedDescription)
            }

            self?.isFetching = false
            self?.isLoadingMore.value = false
        }
    }

    func hidePosts(postCellViewModels: [PostCellViewModel]) {
        guard var snapshot = dataSnapshot.value else { return }
        snapshot.deleteItems(postCellViewModels)
        dataSnapshot.value = snapshot
        handleEmptyState()
    }

    func updateSnapshot(posts: [RedditPost], append: Bool = true) {
        let newPosts = posts.filter { [weak self] newPost -> Bool in
            self?.allPosts.first { $0.id == newPost.id } == nil
        }

        defer {
            allPosts += newPosts
            handleEmptyState()
        }

        let newPostCellViewModels = createPostCellViewModels(from: newPosts)

        guard var snapshot = dataSnapshot.value else {
            var snapshot = NSDiffableDataSourceSnapshot<Int, PostCellViewModel>()
            snapshot.appendSections([0])
            snapshot.appendItems(newPostCellViewModels)
            dataSnapshot.value = snapshot

            return
        }

        guard newPostCellViewModels.count > 0 else { return }

        if let firstItemIdentifier = snapshot.itemIdentifiers.first, append == false {
            snapshot.insertItems(newPostCellViewModels, beforeItem: firstItemIdentifier)
        } else {
            snapshot.appendItems(newPostCellViewModels)
        }

        dataSnapshot.value = snapshot
    }

    func createPostCellViewModels(from posts: [RedditPost]) -> [PostCellViewModel] {
        return posts.map {
            DependencyFactory.shared.postCellViewModel(post: $0)
        }.filter { [weak self] postCellViewModel -> Bool in
            self?.persistanceService.isHidden(redditPost: postCellViewModel.post) == false
        }
    }

    func createRequestErrorAlert() {
        alert.value = UIAlertController.alertWith(title: "Error", message: "Something went wrong", buttonTitle: "Ok")
    }

    func handleEmptyState() {
        dismissAllButtonEnabled.value = (dataSnapshot.value?.numberOfItems ?? 0) > 0
        showEmptyListMessage.value = (dataSnapshot.value?.numberOfItems ?? 0) == 0
    }
}
