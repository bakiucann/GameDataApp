//
//  GameDetailView.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit

class GameDetailViewController: UIViewController {
    private let viewModel: GameDetailViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let ratingLabel = UILabel()
    private let metacriticLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let descriptionLabel = UILabel()

    private var favoriteButton: UIBarButtonItem?

    init(game: Game) {
        self.viewModel = GameDetailViewModel(game: game)
        super.init(nibName: nil, bundle: nil)
        title = game.name
    }

    required init?(coder aDecoder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        metacriticLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(metacriticLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            metacriticLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            metacriticLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            metacriticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            releaseDateLabel.topAnchor.constraint(equalTo: metacriticLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            descriptionLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        nameLabel.font = UIFont.preferredFont(forTextStyle:.headline)
        ratingLabel.font = UIFont.preferredFont(forTextStyle:.subheadline)
        ratingLabel.textColor = .secondaryLabel
        metacriticLabel.font = UIFont.preferredFont(forTextStyle:.subheadline)
        metacriticLabel.textColor = .secondaryLabel
        releaseDateLabel.font = UIFont.preferredFont(forTextStyle:.subheadline)
        releaseDateLabel.textColor = .secondaryLabel
        descriptionLabel.font = UIFont.preferredFont(forTextStyle:.body)
        descriptionLabel.numberOfLines = 0
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton

        viewModel.reloadView = { [weak self] in
            DispatchQueue.main.async {
                self?.updateView()
                self?.updateFavoriteButton()
            }
        }

        viewModel.fetchGameDetail()
    }

    private func updateView() {
        guard let gameDetail = viewModel.gameDetail else { return }

        nameLabel.text = gameDetail.name
        ratingLabel.text = "Rating: \(gameDetail.rating ?? 0)/\(gameDetail.ratingTop ?? 0)"
        metacriticLabel.text = "Metacritic: \(gameDetail.metacritic ?? 0)"
        releaseDateLabel.text = "Release Date: \(gameDetail.released ?? "Unknown")"
        descriptionLabel.text = gameDetail.descriptionRaw

        if let backgroundImage = gameDetail.backgroundImage, let url = URL(string: backgroundImage) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
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
