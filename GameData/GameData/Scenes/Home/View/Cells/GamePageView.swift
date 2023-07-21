//
//  GamePageView.swift
//  GameData
//
//  Created by Baki Uçan on 12.07.2023.
//

import UIKit

// `GamePageView`, UIView sınıfını miras alır ve oyun detaylarını görüntülemek için özel elemanlar içerir.
class GamePageView: UIView {
    // Oyun resmi için UIImageView elemanı oluşturulur.
    let imageView = UIImageView()

    // Oyun adı için UILabel elemanı oluşturulur.
    let titleLabel = UILabel()

    // Oyun derecesi için UILabel elemanı oluşturulur.
    let ratingLabel = UILabel()

    // Görüntülenecek olan oyun verisi.
    var game: Game!

    // Programatik olarak oluşturulan görünümün yapıcı metodu.
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Görüntü için imageView oluşturulur ve ayarlanır.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        // Oyun adını gösterecek titleLabel oluşturulur ve ayarlanır.
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        // Oyun derecesini gösterecek ratingLabel oluşturulur ve ayarlanır.
        ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        ratingLabel.textColor = .white
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingLabel)

        // Elemanların konumlandırılması için kısıtlamalar belirlenir.
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

        // Resmin köşeleri yuvarlatılır ve kenarları kırpılır.
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }

    // Storyboard kullanılarak oluşturulan görünümün yapıcı metodu, burada kullanılmaz.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Görünüm, belirtilen oyun verisi ile yapılandırılır ve içerik doldurulur.
    func configure(with game: Game) {
        self.game = game

        // Oyun resmi URL'ye dönüştürülür ve UIImageView içine yüklenir.
        if let backgroundImage = game.backgroundImage, let url = URL(string: backgroundImage) {
            imageView.loadImage(from: url, placeholder: nil)
        }

        // Oyun adı titleLabel içine yerleştirilir.
        titleLabel.text = game.name

        // Oyun derecesi ratingLabel içine yerleştirilir.
        if let rating = game.rating {
            ratingLabel.text = "Rating: \(rating)"
        } else {
            ratingLabel.text = "Rating: N/A"
        }
    }
}
