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
import Combine
import Kingfisher

protocol PostDetailViewModelProtocol {
    var authorName: String { get }
    var title: String { get }
    var showMedia: Bool { get }
    var mediaNotSupportedText: String { get }
    var postImage: CurrentValueSubject<UIImage?, Never> { get }
    var postImageLoading: CurrentValueSubject<Bool, Never> { get }
    var alert: CurrentValueSubject<UIAlertController?, Never> { get }
    var imageDownloadProgress: CurrentValueSubject<String, Never> { get }

    func saveImage()
}

final class PostDetailViewModel: NSObject, PostDetailViewModelProtocol {
    let authorName: String
    let title: String
    let showMedia: Bool
    let mediaNotSupportedText: String
    let postImage: CurrentValueSubject<UIImage?, Never>
    let alert: CurrentValueSubject<UIAlertController?, Never>
    let postImageLoading: CurrentValueSubject<Bool, Never> = CurrentValueSubject(true)
    let imageDownloadProgress = CurrentValueSubject<String, Never>("")

    init(post: RedditPost) {
        authorName = post.author
        title = post.title
        showMedia = post.postHint == .image
        mediaNotSupportedText = "media_not_supported".localized()
        postImage = CurrentValueSubject(nil)
        alert = CurrentValueSubject(nil)

        super.init()

        guard let url = post.url, showMedia else { return }
        postImageLoading.value = true

        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(
            with: resource,
            options: nil,
            progressBlock: { [weak self] receivedSize, totalSize in
                let bytesToMb: Float = 1/1024/2024
                let received = String(format: "%.3f", Float(receivedSize)*bytesToMb)
                let total = String(format: "%.3f", Float(totalSize)*bytesToMb)

                self?.imageDownloadProgress.value = "\(received)/\(total) MB"
            },
            downloadTaskUpdated: nil) { [weak self] result in
                self?.postImageLoading.value = false
                switch result {
                    case .success(let value):
                        self?.postImage.value = value.image
                    case .failure:
                        self?.createAlert(
                            title: "generic_error".localized(),
                            message: "image_download_error".localized()
                        )
                }
            }
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
            title: error != nil ? "image_save_error".localized() : "image_save_success".localized(),
            message: error != nil ? error?.localizedDescription ?? "" : "image_added_to_gallery".localized()
        )
    }
}

private extension PostDetailViewModel {

    func requestPhotosAuthorization() {
        let handleErrorStatus = { [weak self] (status: PHAuthorizationStatus) in
            guard status == .denied || status == .restricted else { return }
            self?.createAlert(
                title: "generic_warning".localized(),
                message: "gallery_permission_detail".localized()
            )
        }

        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                handleErrorStatus(status)

                if status == .authorized {
                    self?.saveImage()
                }
            }
        }

        handleErrorStatus(status)
    }

    func createAlert(title: String?, message: String?) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController.alertWith(
                title: title,
                message: message,
                buttonTitle: "generic_ok".localized()
            )
            self?.alert.value = alert
        }
    }
}
