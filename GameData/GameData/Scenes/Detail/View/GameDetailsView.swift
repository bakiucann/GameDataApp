//
//  GameDetailView.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit

class GameDetailViewController:UIViewController {
    private let viewModel : GameDetailViewModel
     let scrollView = UIScrollView()
     let contentView = UIView()
     let imageView = UIImageView()
     let nameLabel = UILabel()
     let ratingLabel = UILabel()
     let metacriticLabel = UILabel()
     let releaseDateLabel = UILabel()
     let descriptionLabel = UILabel()
     var favoriteButton : UIBarButtonItem?

    init(game : Game) {
        self.viewModel = GameDetailViewModel(game : game)
        super.init(nibName:nil,bundle:nil)
        title = game.name
    }

    required init?(coder aDecoder:NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()

      setupViews()
      setupConstraints()
      setupFonts()
      setupImageSize()
      setupFavoriteButton()

      viewModel.reloadView={ [weak self] in
          DispatchQueue.main.async {
              self?.updateView()
              self?.updateFavoriteButton()
          }
      }

      viewModel.fetchGameDetail()
    }

    private func setupImageSize() {
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }

    private func setupFavoriteButton() {
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    private func updateView() {
        guard let gameDetail = viewModel.gameDetail else { return }

        nameLabel.text = gameDetail.name
        ratingLabel.text = "Rating: \(gameDetail.rating ?? 0)/\(gameDetail.ratingTop ?? 0)"
        metacriticLabel.text = "Metacritic: \(gameDetail.metacritic ?? 0)"
        releaseDateLabel.text = "Release Date: \(gameDetail.released ?? "Unknown")"
        descriptionLabel.text = gameDetail.descriptionRaw

      if let backgroundImage = gameDetail.backgroundImage, let url = URL(string: backgroundImage) {
          imageView.loadImage(from: url, placeholder: nil)
      }
    }

    private func updateFavoriteButton() {
        let isFavorite = viewModel.isFavorite()
        let heartImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favoriteButton?.image = heartImage
    }

    @objc private func favoriteButtonTapped() {
        if viewModel.isFavorite() {
            viewModel.removeFromFavorites()
        } else {
            viewModel.addToFavorites()
        }
        updateFavoriteButton()
    }
}
