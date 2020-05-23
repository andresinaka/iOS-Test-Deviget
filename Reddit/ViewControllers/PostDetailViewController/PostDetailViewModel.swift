//
//  PostDetailViewModel.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol PostDetailViewModelProtocol {
    var authorName: String { get }
    var title: String { get }
    var showMedia: Bool { get }
    var mediaNotSupportedText: String { get }
    var postImage: Observable<UIImage?> { get }
    var postImageLoading: Observable<Bool> { get }
    var alert: Observable<UIAlertController?> { get }

    func saveImage()
}

final class PostDetailViewModel: NSObject, PostDetailViewModelProtocol {
    let authorName: String
    let title: String
    let showMedia: Bool
    let mediaNotSupportedText: String
    let postImage: Observable<UIImage?>
    let alert: Observable<UIAlertController?>
    let postImageLoading: Observable<Bool> = Observable(true)

    init(apiService: ApiServiceProtocol, post: RedditPost) {
        authorName = post.author
        title = post.title
        showMedia = post.postHint == .image
        mediaNotSupportedText = "No images available"
        postImage = Observable(nil)
        alert = Observable(nil)

        super.init()

        guard let url = post.url, showMedia else { return }
        postImageLoading.value = true
        apiService.downloadImage(imageURL: url) { [weak self] result in
            self?.postImageLoading.value = false
            switch result {
            case .success(let image):
                self?.postImage.value = image
            case .failure:
                self?.createAlert(title: "Error", message: "Error downloading Image")
            }
        }?.resume()
    }

    func saveImage() {
        guard PHPhotoLibrary.authorizationStatus() == .authorized  else {
            requestPhotosAuthorization()
            return
        }

        guard let image = postImage.value else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        createAlert(
            title: error != nil ? "Save Error" : "Saved Successfully",
            message: error != nil ? error?.localizedDescription ?? "" : "The image was added to your gallery"
        )
    }
}

private extension PostDetailViewModel {

    func requestPhotosAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .denied {
                    self?.createAlert(title: "Warning!", message: "Error with Gallery Permissions")
                }

                if status == .authorized {
                    self?.saveImage()
                }
            }
        }

        if status == .denied || status == .restricted {
            createAlert(title: "Warning!", message: "Error with Gallery Permissions")
        }
    }

    func createAlert(title: String?, message: String?) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController.alertWith(title: title, message: message, buttonTitle: "Ok")
            self?.alert.value = alert
        }
    }
}
