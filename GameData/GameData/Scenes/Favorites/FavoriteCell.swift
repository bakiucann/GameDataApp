//
//  FavoriteCell.swift
//  GameData
//
//  Created by Baki Uçan on 16.07.2023.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    static let reuseIdentifier = "FavoriteCell"

    let imageView = UIImageView()
    let nameLabel = UILabel()
    let ratingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func openGameDetail() {
        guard let game = game else {
            return
        }

        let gameDetailViewController = GameDetailViewController(game: game)
        findViewController()?.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }

    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }

    private var game: Game?

    func configure(with game: Game) {
        self.game = game
        nameLabel.text = game.name
        ratingLabel.text = "Rating : \(game.rating ?? 0)"

        if let backgroundImage = game.backgroundImage, let url = URL(string: backgroundImage) {
            URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data, let image = UIImage(data: data) {
                  DispatchQueue.main.async {
                      self.imageView.image = image
                  }
              }

            }.resume()
        }
    }
}
