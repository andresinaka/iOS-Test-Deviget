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
    let authorName: String
    let title: String
    let showMedia: Bool
    let mediaNotSupportedText: String
    let postImage: Observable<UIImage?>

    init(apiService: ApiServiceProtocol, post: RedditPost) {
        authorName = post.author
        title = post.title
        showMedia = post.postHint == .image
        mediaNotSupportedText = "No images available"
        postImage = Observable(nil)

        guard let imageURL = post.url, showMedia else { return }
        apiService.downloadImage(imageURL: imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.postImage.value = image
            case .failure:
                print("ERROR")
            }
        }?.resume()
    }
}
