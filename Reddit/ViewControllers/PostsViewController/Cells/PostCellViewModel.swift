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
    var unread: Bool { get }
    var dismissButtonTitle: String { get }
    var showThumbnail: Bool { get }
    var postImage: Observable<UIImage?> { get }
    var post: RedditPost { get }

    func downloadImage()
}

final class PostCellViewModel: PostCellViewModelProtocol {

    let post: RedditPost

    var authorName: String
    var title: String
    var commentsText: String
    var timeAgo: String
    var unread: Bool
    var dismissButtonTitle: String
    var showThumbnail: Bool
    var postImage: Observable<UIImage?>

    private var apiService: ApiServiceProtocol
    private var downloadImageTask: URLSessionDataTask?

    init(apiService: ApiServiceProtocol, post: RedditPost) {
        self.apiService = apiService
        self.post = post

        authorName = post.author
        title = post.title
        commentsText = "\(post.numComments) Comments"
        timeAgo = post.createdUTC.timeAgoDisplay()
        unread = false
        dismissButtonTitle = "Dismiss Post"
        showThumbnail = post.thumbnailURL != nil
        postImage = Observable(nil)

        guard let thumbnailURL = post.thumbnailURL else { return }
        downloadImageTask = apiService.downloadImage(imageURL: thumbnailURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.postImage.value = image
            case .failure:
                print("ERROR")
            }
        }
    }

    func downloadImage() {
        guard downloadImageTask?.state == .suspended else { return }
        downloadImageTask?.resume()
    }
}
