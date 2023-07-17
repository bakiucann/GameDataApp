//
//  GamePageView.swift
//  GameData
//
//  Created by Baki Uçan on 12.07.2023.
//

import UIKit

class GamePageView: UIView {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let ratingLabel = UILabel()

    var game: Game!

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        ratingLabel.textColor = .white
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            ratingLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8)
        ])

        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with game: Game) {
        self.game = game

        if let backgroundImage = game.backgroundImage, let url = URL(string: backgroundImage) {
            imageView.loadImage(from: url, placeholder: nil)
        }

        titleLabel.text = game.name

        if let rating = game.rating {
            ratingLabel.text = "Rating: \(rating)"
        } else {
            ratingLabel.text = "Rating: N/A"
        }
    }
}
