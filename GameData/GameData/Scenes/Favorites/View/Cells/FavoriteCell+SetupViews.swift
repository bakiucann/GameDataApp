//
//  FavoriteCell+SetupViews.swift
//  GameData
//
//  Created by Baki Uçan on 18.07.2023.
//

import UIKit

extension FavoriteCell {
    func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)

      NSLayoutConstraint.activate([
          imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
          imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          imageView.widthAnchor.constraint(equalToConstant: 100),
          imageView.heightAnchor.constraint(equalToConstant: 100),

          nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
          nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

          ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
          ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
      ])


        nameLabel.font = UIFont.preferredFont(forTextStyle:.headline)
        ratingLabel.font = UIFont.preferredFont(forTextStyle:.subheadline)
        ratingLabel.textColor = .secondaryLabel
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.font = UIFont.systemFont(ofSize: 11)

        nameLabel.numberOfLines = 0
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGameDetail))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }
}
