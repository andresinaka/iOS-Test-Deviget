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
    private var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()

        viewModel?.fetchPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectTableViewRows()
    }

    @objc func refreshPosts(refreshControl: UIRefreshControl) {
        viewModel?.postCellViewModels.value = []

        refreshControl.endRefreshing()
    }
}

private extension PostsViewController {

    func setupViews() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableView.delegate = self
        tableView.dataSource = self
    }

    func bindViewModel() {
        viewModel?.postCellViewModels.bind { [weak self] _ in
            self?.tableView.reloadData()
        }

        viewModel?.title.bind { [weak self] title in
            self?.title = title
        }
    }

    func deselectTableViewRows() {
        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.postCellViewModels.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cellViewModel = viewModel?.postCellViewModels.value[indexPath.row],
            let postCell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier) as? PostCell
        else { return UITableViewCell() }

        postCell.setup(with: cellViewModel)
        return postCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PostDetailViewControllerId")

        show(viewController, sender: nil)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel?.postCellViewModels.value[indexPath.row]
        cellViewModel?.downloadImage()
    }
}
