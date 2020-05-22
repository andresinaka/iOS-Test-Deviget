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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
    }

    deinit {
        print("Deinited")
    }
}

private extension PostDetailViewController {

    func setupViews() {

    }

    func bindViewModel() {
        authorNameLabel.text = viewModel?.authorName
        titleLabel.text = viewModel?.title

        let hideMedia = !(viewModel?.showMedia ?? true)
        mediaImageView.isHidden = hideMedia
        mediaNotSupportedLabel.isHidden = !hideMedia
        mediaNotSupportedLabel.text = viewModel?.mediaNotSupportedText

        viewModel?.postImage.bind { [weak self] postImage in
            self?.mediaImageView.image = postImage
        }
    }
}
