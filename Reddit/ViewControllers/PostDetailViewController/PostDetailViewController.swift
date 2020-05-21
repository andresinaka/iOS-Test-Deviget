//
//  PostDetailViewController.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import UIKit

final class PostDetailViewController: UIViewController {

    var viewModel: PostDetailViewModelProtocol? = PostDetailViewModel()

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

        viewModel?.title.bind({ [weak self] title in
            self?.title = title
        })
    }

}
