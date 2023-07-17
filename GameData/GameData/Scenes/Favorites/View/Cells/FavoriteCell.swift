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
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func openGameDetail() {
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
            imageView.loadImage(from: url, placeholder: nil)
        }
    }
}
