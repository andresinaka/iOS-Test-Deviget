//
//  PostDetailViewController.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import UIKit
import Combine

final class PostDetailViewController: UIViewController {

    var viewModel: PostDetailViewModelProtocol?

    lazy var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaNotSupportedLabel: UILabel!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
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

        viewModel?.postImage.sink { [weak self] postImage in
            self?.mediaImageView.image = postImage
            self?.saveImageButton?.isEnabled = postImage != nil
            self?.activityIndicator?.isHidden = postImage != nil
            self?.progressLabel?.isHidden = postImage != nil
        }.store(in: &cancellables)

        viewModel?.imageDownloadProgress.sink { [weak self] progress in
            self?.progressLabel.text = progress
        }.store(in: &cancellables)

        viewModel?.postImageLoading.sink { [weak self] postImageLoading in
            self?.activityIndicator.isHidden = !postImageLoading
        }.store(in: &cancellables)

        viewModel?.alert.sink { [weak self] alertController in
            guard let alertController = alertController else { return }
            self?.present(alertController, animated: true, completion: nil)
        }.store(in: &cancellables)
    }
}
