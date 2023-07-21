//
//  GameDetailView.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit

// Oyun detaylarını görüntülemek için GameDetailViewController sınıfını oluşturuyoruz.
class GameDetailViewController: UIViewController {
    // GameDetailViewModel sınıfını örnekleyerek view modelini tanımlıyoruz.
    private let viewModel: GameDetailViewModel

    // Görünüm elemanlarını tanımlıyoruz.
    let scrollView = UIScrollView()
    let contentView = UIView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let ratingLabel = UILabel()
    let metacriticLabel = UILabel()
    let releaseDateLabel = UILabel()
    let descriptionLabel = UILabel()
    var favoriteButton: UIBarButtonItem?

    // Gelen oyun verisiyle bir GameDetailViewController örneği oluşturuyoruz.
    init(game: Game) {
        self.viewModel = GameDetailViewModel(game: game)
        super.init(nibName: nil, bundle: nil)
        title = game.name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Görünüm elemanlarını oluşturan yardımcı yöntemleri çağırıyoruz.
        setupViews()
        setupConstraints()
        setupFonts()
        setupImageSize()
        setupFavoriteButton()

        // View modeldeki reloadView kapatma bloğunu güncelleyerek oyun detaylarını görüntülemek için view modeli kullanıyoruz.
        viewModel.reloadView = { [weak self] in
            DispatchQueue.main.async {
                self?.updateView()
                self?.updateFavoriteButton()
            }
        }

        // Oyun detaylarını almak için view modeli kullanıyoruz.
        viewModel.fetchGameDetail()
    }

    // Oyun detayı resminin boyutunu ayarlayan yöntemi tanımlıyoruz.
    // Not: Constraints hataları bu kısımdan kaynaklanıyor. API tarafından gelen resimler düzgün olmadığı için bu şekilde sabit ölçüler tanımladım.
    private func setupImageSize() {
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }

    // Favorilere ekleme/kaldırma düğmesini ayarlayan yöntemi tanımlıyoruz.
    private func setupFavoriteButton() {
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    // Görünümü güncelleyen yöntemi tanımlıyoruz.
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

    // Favorilere ekleme/kaldırma düğmesini güncelleyen yöntemi tanımlıyoruz.
    private func updateFavoriteButton() {
        let isFavorite = viewModel.isFavorite()
        let heartImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favoriteButton?.image = heartImage
    }

    // Favorilere ekleme/kaldırma düğmesine basıldığında çağrılacak yöntemi tanımlıyoruz.
    @objc private func favoriteButtonTapped() {
        if viewModel.isFavorite() {
            showRemoveFavoriteAlert()
        } else {
            viewModel.addToFavorites()
        }
        updateFavoriteButton()
    }

    // Kullanıcıya favorilerden kaldırmak istediğine dair bir uyarı gösteren yöntemi tanımlıyoruz.
    private func showRemoveFavoriteAlert() {
        let alert = UIAlertController(title: "Remove from Favorites", message: "Are you sure you want to remove this game from your favorites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
            self.viewModel.removeFromFavorites()
            self.updateFavoriteButton()
        }))
        present(alert, animated: true, completion: nil)
    }
}
