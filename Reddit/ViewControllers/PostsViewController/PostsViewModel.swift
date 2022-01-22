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
import Combine

protocol PostsViewModelProtocol {

    var dataSnapshot: CurrentValueSubject<NSDiffableDataSourceSnapshot<Int, PostCellViewModel>?, Never> { get }
    var dismissAllButtonEnabled: CurrentValueSubject<Bool, Never> { get }
    var alert: CurrentValueSubject<UIAlertController?, Never> { get }
    var isPullingToRefresh: CurrentValueSubject<Bool, Never> { get }
    var isLoadingMore: CurrentValueSubject<Bool, Never> { get }
    var showEmptyListMessage: CurrentValueSubject<Bool, Never> { get }
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
    let title = "title_posts".localized()
    let dismissAllButtonTitle = "dismiss_all".localized()
    let emptyListMessage = "pull_to_refresh".localized()

    private var apiService: ApiServiceProtocol
    private var persistenceService: PersistenceServiceProtocol
    private var allPosts: [RedditPost] = []
    private var nextPageAfter: String?
    private(set) var isFetching: Bool = false

    let dataSnapshot: CurrentValueSubject<NSDiffableDataSourceSnapshot<Int, PostCellViewModel>?, Never> = CurrentValueSubject(nil)
    let dismissAllButtonEnabled: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let alert: CurrentValueSubject<UIAlertController?, Never> = CurrentValueSubject(nil)
    let isPullingToRefresh: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let showEmptyListMessage: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let isLoadingMore: CurrentValueSubject<Bool, Never> = CurrentValueSubject(true)

    init(apiService: ApiServiceProtocol, persistenceService: PersistenceServiceProtocol) {
        self.apiService = apiService
        self.persistenceService = persistenceService
    }

    func fetchFirstPage() {
        fetchPosts(after: nil)
    }

    func fetchNextPage() {
        isLoadingMore.value = true
        fetchPosts(after: nextPageAfter)
    }

    func dismissPost(postCellViewModel: PostCellViewModel) {
        persistenceService.setHidden(redditPost: postCellViewModel.post)
        hidePosts(postCellViewModels: [postCellViewModel])
    }

    func dismissAll() {
        let viewModels = dataSnapshot.value?.itemIdentifiers(inSection: 0) ?? []
        for viewModel in viewModels {
            persistenceService.setHidden(redditPost: viewModel.post)
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
            self?.persistenceService.isHidden(redditPost: postCellViewModel.post) == false
        }
    }

    func createRequestErrorAlert() {
        alert.value = UIAlertController.alertWith(
            title: "generic_error".localized(),
            message: "generic_error_message".localized(),
            buttonTitle: "generic_ok".localized()
        )
    }

    func handleEmptyState() {
        dismissAllButtonEnabled.value = (dataSnapshot.value?.numberOfItems ?? 0) > 0
        showEmptyListMessage.value = (dataSnapshot.value?.numberOfItems ?? 0) == 0
    }
}
