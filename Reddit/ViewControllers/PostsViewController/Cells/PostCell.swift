//
//  PostCell.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import UIKit

final class PostCell: UITableViewCell {
    static var identifier = "PostCell"

    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        unreadView.layer.cornerRadius = 5
        thumbnailImageView.layer.cornerRadius = 3
    }

    func setup(with viewModel: PostCellViewModelProtocol) {
        viewModel.authorName.bind { [weak self] authorName in
            self?.authorNameLabel.text = authorName
        }

        viewModel.unread.bind { [weak self] unread in
            self?.unreadView.isHidden = unread
        }

        viewModel.title.bind { [weak self] title in
            self?.titleLabel.text = title
        }

        viewModel.commentsText.bind { [weak self] commentsText in
            self?.commentsCountLabel.text = commentsText
        }

        viewModel.dismissButtonTitle.bind { [weak self] dismissButtonTitle in
            self?.dismissButton.setTitle(dismissButtonTitle, for: .normal)
        }

        viewModel.timeAgo.bind { [weak self] timeAgo in
            self?.timeAgoLabel.text = timeAgo
        }

        viewModel.showThumbnail.bind { [weak self] showThumbnail in
            self?.thumbnailImageView.isHidden = !showThumbnail
        }

        viewModel.postImage.bind { [weak self] image in
            self?.thumbnailImageView.image = image
        }
    }
}
