//
//  FavoriteCell.swift
//  GameData
//
//  Created by Baki Uçan on 16.07.2023.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    static let reuseIdentifier = "FavoriteCell"

    // Hücre içerisinde yer alacak görsel ve metin nesneleri tanımlanır.
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

    // Oyun detay sayfasını açmak için kullanılan yöntem.
    @objc func openGameDetail() {
        guard let game = game else {
            return
        }

        // Seçilen oyunun detaylarını göstermek için GameDetailViewController örneği oluşturulur ve açılır.
        let gameDetailViewController = GameDetailViewController(game: game)
        findViewController()?.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }

    // Hücrenin yer aldığı görünüm hiyerarşisinde bulunan ilk UIView'ı bulmak için kullanılan yöntem.
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

    // Hücreyi veriyle yapılandırmak için kullanılan yöntem.
    func configure(with game: Game) {
        self.game = game
        nameLabel.text = game.name
        ratingLabel.text = "Rating : \(game.rating ?? 0)"

        // Oyunun arka plan resmini yükleme ve görseli imageView'a atama işlemleri.
        if let backgroundImage = game.backgroundImage, let url = URL(string: backgroundImage) {
            imageView.loadImage(from: url, placeholder: nil)
        }
    }
}
