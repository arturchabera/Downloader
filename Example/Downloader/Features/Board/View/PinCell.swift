//
//  PinCell.swift
//  Downloader_Example
//
//  Created by Majid Jabrayilov on 5/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Downloader

class PinCell: UICollectionViewCell {
    @IBOutlet private weak var pinImageView: UIImageView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!

    private var tokens: [CancellationToken] = []

    var presentation: PinPresentation? {
        didSet {
            guard let presentation = presentation else {
                return
            }

            usernameLabel.text = presentation.username

            if let imageUrl = presentation.imageUrl {
                let token = pinImageView.setImage(from: imageUrl)
                token.map { tokens.append($0) }
            }

            if let avatarUrl = presentation.avatarUrl {
                let token = userImageView.setImage(from: avatarUrl)
                token.map { tokens.append($0) }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tokens.forEach { $0.cancel() }
        tokens.removeAll()
        pinImageView.image = nil
        userImageView.image = nil
    }
}

extension PinCell: NibReusableView {}
