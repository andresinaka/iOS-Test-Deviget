//
//  PostCellViewModel.swift
//  Reddit
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol PostCellViewModelProtocol {
    var authorName: String { get }
    var title: String { get }
    var commentsText: String { get }
    var timeAgo: String { get }
    var dismissButtonTitle: String { get }
    var showThumbnail: Bool { get }
    var unread: CurrentValueSubject<Bool, Never> { get }
    var post: RedditPost { get }
    var postImageURL: URL? { get }
    var thumbnailURL: URL? { get }

    func markAsRead()
}

final class PostCellViewModel: Hashable, PostCellViewModelProtocol {

    let post: RedditPost

    let authorName: String
    let title: String
    let commentsText: String
    let timeAgo: String
    let dismissButtonTitle: String
    let showThumbnail: Bool
    let unread: CurrentValueSubject<Bool, Never>
    let postImageURL: URL?
    let thumbnailURL: URL?

    private var apiService: ApiServiceProtocol
    private var persistenceService: PersistenceServiceProtocol

    private var downloadImageTask: URLSessionDataTask?

    init(apiService: ApiServiceProtocol, persistenceService: PersistenceServiceProtocol, post: RedditPost) {
        self.apiService = apiService
        self.post = post
        self.persistenceService = persistenceService

        authorName = post.author
        title = post.title
        commentsText = "comments".localized(args: post.numComments)
        timeAgo = post.createdUTC.timeAgoDisplay()
        dismissButtonTitle = "dismiss_post".localized()
        showThumbnail = post.thumbnailURL != nil
        unread = CurrentValueSubject(!persistenceService.isRead(redditPost: post))
        thumbnailURL = post.thumbnailURL
        postImageURL = post.postHint == RedditPost.PostHint.image ? post.url : nil
    }

    func markAsRead() {
        persistenceService.setRead(redditPost: post)
        unread.value = false
    }

    static func == (lhs: PostCellViewModel, rhs: PostCellViewModel) -> Bool {
        lhs.post.id == rhs.post.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(post.id)
    }
}
