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
        authorNameLabel.text = viewModel.authorName
        unreadView.isHidden = viewModel.unread
        titleLabel.text = viewModel.title
        commentsCountLabel.text = viewModel.commentsText
        dismissButton.setTitle(viewModel.dismissButtonTitle, for: .normal)
        timeAgoLabel.text = viewModel.timeAgo
        thumbnailImageView.isHidden = !viewModel.showThumbnail

        viewModel.postImage.bind { [weak self] image in
            self?.thumbnailImageView.image = image
        }
    }
}
