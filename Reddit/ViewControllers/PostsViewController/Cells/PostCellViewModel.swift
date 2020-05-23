//
//  PostCellViewModel.swift
//  Reddit
//
//  Created by Andres Canal on 21/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit

protocol PostCellViewModelProtocol {
    var authorName: String { get }
    var title: String { get }
    var commentsText: String { get }
    var timeAgo: String { get }
    var dismissButtonTitle: String { get }
    var showThumbnail: Bool { get }
    var postImage: Observable<UIImage?> { get }
    var unread: Observable<Bool> { get }
    var post: RedditPost { get }
    var postImageURL: URL? { get }

    func downloadImage()
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
    let postImage: Observable<UIImage?>
    let unread: Observable<Bool>
    let postImageURL: URL?

    private var apiService: ApiServiceProtocol
    private var persistanceService: PersistenceServiceProtocol
    private var thumbnailURL: URL?
    private var downloadImageTask: URLSessionDataTask?

    init(apiService: ApiServiceProtocol, persistanceService: PersistenceServiceProtocol, post: RedditPost) {
        self.apiService = apiService
        self.post = post
        self.persistanceService = persistanceService

        authorName = post.author
        title = post.title
        commentsText = "\(post.numComments) Comments"
        timeAgo = post.createdUTC.timeAgoDisplay()
        dismissButtonTitle = "Dismiss Post"
        showThumbnail = post.thumbnailURL != nil
        postImage = Observable(nil)
        unread = Observable(!persistanceService.isRead(redditPost: post))
        thumbnailURL = post.thumbnailURL
        postImageURL = post.postHint == RedditPost.PostHint.image ? post.url : nil
    }

    func downloadImage() {
        guard downloadImageTask == nil, let thumbnailURL = thumbnailURL else { return }
        downloadImageTask = apiService.downloadImage(imageURL: thumbnailURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.postImage.value = image
            case .failure:
                print("ERROR")
            }
        }
        downloadImageTask?.resume()
    }

    func markAsRead() {
        persistanceService.setRead(redditPost: post)
        unread.value = false
    }

    static func == (lhs: PostCellViewModel, rhs: PostCellViewModel) -> Bool {
        lhs.post.id == rhs.post.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(post.id)
    }
}
