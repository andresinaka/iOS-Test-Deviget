//
//  PostCell.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

protocol PostCellDelegate: AnyObject {
    func dismissTapped(cell: PostCell)
    func open(url: URL)
}

final class PostCell: UITableViewCell {
    static var identifier = "PostCell"

    lazy var cancellables = Set<AnyCancellable>()
    weak var delegate: PostCellDelegate?

    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!

    private var mediaURL: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
        unreadView.layer.cornerRadius = 5
        thumbnailImageView.layer.cornerRadius = 3

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openURL))
        thumbnailImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @IBAction func dismissPost(_ sender: Any) {
        delegate?.dismissTapped(cell: self)
    }

    func setup(with viewModel: PostCellViewModelProtocol) {
        authorNameLabel.text = viewModel.authorName
        titleLabel.text = viewModel.title
        commentsCountLabel.text = viewModel.commentsText
        dismissButton.setTitle(viewModel.dismissButtonTitle, for: .normal)
        timeAgoLabel.text = viewModel.timeAgo
        thumbnailImageView.isHidden = !viewModel.showThumbnail

        thumbnailImageView.kf.setImage(
            with: viewModel.thumbnailURL,
            placeholder: nil,
            options: nil,
            completionHandler: nil
        )

        viewModel.unread.sink { [weak self] unread in
            self?.unreadView.isHidden = !unread
        }.store(in: &cancellables)

        mediaURL = viewModel.postImageURL
    }

    @objc func openURL() {
        guard let mediaURL = mediaURL else { return }
        delegate?.open(url: mediaURL)
    }
}
