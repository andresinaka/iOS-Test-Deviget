//
//  PostDetailViewController.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import UIKit

final class PostDetailViewController: UIViewController {

    var viewModel: PostDetailViewModelProtocol?

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaNotSupportedLabel: UILabel!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var saveImageButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
    }

    @objc func saveImage() {
        viewModel?.saveImage()
    }
}

private extension PostDetailViewController {

    func setupViews() {
        let saveImageButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveImage))
        navigationItem.rightBarButtonItems = [saveImageButton]
        saveImageButton.isEnabled = false

        self.saveImageButton = saveImageButton
    }

    func bindViewModel() {
        authorNameLabel.text = viewModel?.authorName
        titleLabel.text = viewModel?.title

        let hideMedia = !(viewModel?.showMedia ?? true)
        imageContainerView.isHidden = hideMedia
        mediaNotSupportedLabel.isHidden = !hideMedia
        mediaNotSupportedLabel.text = viewModel?.mediaNotSupportedText

        viewModel?.postImage.bind { [weak self] postImage in
            self?.mediaImageView.image = postImage
            self?.saveImageButton?.isEnabled = postImage != nil
            self?.activityIndicator?.isHidden = postImage != nil
        }

        viewModel?.postImageLoading.bind { [weak self] postImageLoading in
            self?.activityIndicator.isHidden = !postImageLoading
        }

        viewModel?.alert.bind { [weak self] alertController in
            guard let alertController = alertController else { return }
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
