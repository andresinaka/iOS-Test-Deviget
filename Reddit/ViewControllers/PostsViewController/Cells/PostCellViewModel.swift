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
    var authorName: Observable<String> { get }
    var title: Observable<String> { get }
    var commentsText: Observable<String> { get }
    var timeAgo: Observable<String> { get }
    var unread: Observable<Bool> { get }
    var dismissButtonTitle: Observable<String> { get }
    var showThumbnail: Observable<Bool> { get }
    var postImage: Observable<UIImage?> { get }

    func downloadImage()
}

final class PostCellViewModel: PostCellViewModelProtocol {

    var authorName: Observable<String>
    var title: Observable<String>
    var commentsText: Observable<String>
    var timeAgo: Observable<String>
    var unread: Observable<Bool>
    var dismissButtonTitle: Observable<String>
    var showThumbnail: Observable<Bool>
    var postImage: Observable<UIImage?>

    private var apiService: ApiServiceProtocol
    private var downloadImageTask: URLSessionDataTask?

    init(apiService: ApiServiceProtocol, post: RedditPost) {
        self.apiService = apiService

        authorName = Observable(post.author)
        title = Observable(post.title)
        commentsText = Observable("\(post.numComments) Comments")
        timeAgo = Observable(post.createdUTC.timeAgoDisplay())
        unread = Observable(false)
        dismissButtonTitle = Observable("Dismiss Post")
        showThumbnail = Observable(post.thumbnailURL != nil)
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
