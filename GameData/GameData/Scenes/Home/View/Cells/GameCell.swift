//
//  GameCell.swift
//  GameData
//
//  Created by Baki Uçan on 12.07.2023.
//

import UIKit
import LoadingManager

// `GameCell`, UICollectionViewCell sınıfını miras alır ve oyunları listeleyen koleksiyon görünümü hücreleri için kullanılır.
class GameCell: UICollectionViewCell {
    // Hücre yeniden kullanılabilir kimliği.
    static let reuseIdentifier = "GameCell"

    // Oyun resmi için UIImageView elemanı oluşturulur.
    let imageView = UIImageView()

    // Oyun adı için UILabel elemanı oluşturulur.
    let nameLabel = UILabel()

    // Oyun derecesi için UILabel elemanı oluşturulur.
    let ratingLabel = UILabel()

    // Programatik olarak oluşturulan görünümün yapıcı metodu.
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Elemanlar için yapılandırmalar yapılır ve contentView'a eklenirler.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)

        // Elemanların konumlandırılması için kısıtlamalar belirlenir.
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // Not: Constraints hataları bu kısımdan kaynaklanıyor. API tarafından gelen resimler düzgün olmadığı için bu şekilde sabit ölçüler tanımladım.
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Elemanların görünümü ve stil ayarları yapılır.
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        ratingLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        ratingLabel.textColor = .secondaryLabel
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.font = UIFont.systemFont(ofSize: 11)
        nameLabel.numberOfLines = 0
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true

        // Hücreye dokunulduğunda oyun detay sayfasına gitmek için bir dokunma tanımlayıcısı eklenir.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGameDetail))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }

    // Storyboard kullanılarak oluşturulan görünümün yapıcı metodu, burada kullanılmaz.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Oyun detay sayfasını açmak için dokunma işlemi tetiklendiğinde çağrılan işlev.
    @objc private func openGameDetail() {
        // Oyun verisi mevcut değilse işlemi durdurur.
        guard let game = game else {
            return
        }
        // Oyun detay sayfasını açmak için LoadingManager başlatılır.
        LoadingManager.shared.startLoading()

        // Oyun detay sayfası oluşturulur ve oyun verisi ile yapılandırılır.
        let gameDetailViewController = GameDetailViewController(game: game)

        // Bulunan view controller'a erişilir ve oyun detay sayfası navigationController üzerine push edilir.
        findViewController()?.navigationController?.pushViewController(gameDetailViewController, animated: true)

        // Oyun detay sayfası açıldıktan sonra LoadingManager durdurulur.
        LoadingManager.shared.stopLoading()
    }

    // Hücrenin içinde bulunduğu view controller'ı bulmak için yardımcı işlev.
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

    // Hücrenin üzerindeki oyun verisi.
    private var game: Game?

    // Hücrenin içeriğini oyun verisi ile doldurmak için kullanılan işlev.
    func configure(with game: Game) {
        self.game = game

        // Oyun adı ve derecesi içeriği doldurulur.
        nameLabel.text = game.name
        ratingLabel.text = "Rating: \(game.rating ?? 0)/\(game.ratingTop ?? 0)"

        // Oyun resmi yüklenir (varsa) ve imageView içine yerleştirilir.
        if let backgroundImage = game.backgroundImage, let url = URL(string: backgroundImage) {
            imageView.loadImage(from: url, placeholder: nil)
        }
    }
}
