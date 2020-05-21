//
//  PostsViewController.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import UIKit

final class PostsViewController: UIViewController {

    var viewModel: PostsViewModelProtocol? = PostsViewModel(apiService: ApiService())

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()

        viewModel?.fetchPosts()
    }
}

private extension PostsViewController {

    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func bindViewModel() {
        viewModel?.posts.bind({ posts in
            print(posts)
        })
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: PostCell.identifier) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PostDetailViewControllerId")

        show(viewController, sender: nil)
    }
}
