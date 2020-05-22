//
//  PostDetailViewModel.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit

protocol PostDetailViewModelProtocol {
    var authorName: String { get }
    var title: String { get }
    var showMedia: Bool { get }
    var mediaNotSupportedText: String { get }
    var postImage: Observable<UIImage?> { get }
}

final class PostDetailViewModel: PostDetailViewModelProtocol {
    var authorName: String
    var title: String
    var showMedia: Bool
    var mediaNotSupportedText: String
    var postImage: Observable<UIImage?>

    init(apiService: ApiServiceProtocol, post: RedditPost) {
        authorName = post.author
        title = post.title
        showMedia = post.postHint == .image
        mediaNotSupportedText = "Media not supported"
        postImage = Observable(nil)

        guard let thumbnailURL = post.url, showMedia else { return }
        apiService.downloadImage(imageURL: thumbnailURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.postImage.value = image
            case .failure:
                print("ERROR")
            }
        }?.resume()
    }
}
