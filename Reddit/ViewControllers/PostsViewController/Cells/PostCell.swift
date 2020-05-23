//
//  PostCell.swift
//  Reddit
//
//  Created by Andres Canal on 20/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import UIKit

protocol PostCellDelegate: class {
    func dismissTapped(cell: PostCell)
    func open(url: URL)
}

final class PostCell: UITableViewCell {
    static var identifier = "PostCell"

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

        viewModel.postImage.bind { [weak self] image in
            self?.thumbnailImageView.image = image
        }

        viewModel.unread.bind { [weak self] unread in
            self?.unreadView.isHidden = !unread
        }

        mediaURL = viewModel.postImageURL
    }

    @objc func openURL() {
        guard let mediaURL = mediaURL else { return }
        delegate?.open(url: mediaURL)
    }
}
