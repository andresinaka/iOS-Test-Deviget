//
//  PostsViewController.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import UIKit
import SafariServices

final class PostsViewController: UIViewController {

    var viewModel: PostsViewModelProtocol? = PostsViewModel(apiService: ApiService(), persistanceService: PersistenceService())

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissAllButton: UIButton!
    private var refreshControl: UIRefreshControl?
    private var dataSource: UITableViewDiffableDataSource<Int, PostCellViewModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()

        viewModel?.fetchFirstPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectTableViewRows()
    }

    @objc func refreshPosts(refreshControl: UIRefreshControl) {
        viewModel?.fetchFirstPage()
    }

    @IBAction func dismissAllAction(_ sender: Any) {
        viewModel?.dismissAll()
    }
}

private extension PostsViewController {

    func setupViews() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl

        dataSource = UITableViewDiffableDataSource<Int, PostCellViewModel>(tableView: tableView) { tableView, indexPath, cellViewModel in
            guard let postCell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier) as? PostCell else { return UITableViewCell() }
            postCell.delegate = self
            postCell.setup(with: cellViewModel)
            cellViewModel.downloadImage()
            return postCell
        }

        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
    }

    func bindViewModel() {
        viewModel?.dataSnapshot.bind { [weak self] snapshot in
            guard let snapshot = snapshot else { return }
            let shouldAnimate = self?.tableView.numberOfSections != 0
            self?.dataSource?.apply(snapshot, animatingDifferences: shouldAnimate, completion: nil)
        }

        viewModel?.dismissAllButtonEnabled.bind { [weak self] dismissAllButtonEnabled in
            self?.dismissAllButton.isEnabled = dismissAllButtonEnabled
        }

        viewModel?.isFetching.bind { [weak self] isFetching in
            self?.refreshControl?.endRefreshing()
        }

        title = viewModel?.title
        dismissAllButton.setTitle(viewModel?.dismissAllButtonTitle, for: .normal)
    }

    func deselectTableViewRows() {
        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
}

extension PostsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailViewController", bundle: nil)
        guard
            let viewController = storyboard.instantiateViewController(withIdentifier: "PostDetailViewControllerId") as? PostDetailViewController,
            let postCellViewModel = dataSource?.itemIdentifier(for: indexPath)
        else { return }

        postCellViewModel.markAsRead()
        viewController.viewModel = PostDetailViewModel(apiService: ApiService(), post: postCellViewModel.post)
        show(viewController, sender: nil)
    }
}

extension PostsViewController: PostCellDelegate {

    func open(url: URL) {
        let safariConfig = SFSafariViewController.Configuration()
        safariConfig.entersReaderIfAvailable = true
        safariConfig.barCollapsingEnabled = true

        let safariViewController = SFSafariViewController(url: url, configuration: safariConfig)
        safariViewController.modalPresentationStyle = .automatic
        present(safariViewController, animated: true, completion: nil)

    }

    func dismissTapped(cell: PostCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let postCellViewModel = dataSource?.itemIdentifier(for: indexPath)
        else { return }

        viewModel?.dismissPost(postCellViewModel: postCellViewModel)
    }
}
