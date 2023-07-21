//
//  FavoritesView.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    let viewModel = FavoritesViewModel()

    // Favori oyunların gösterildiği koleksiyon görünümü.
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Favori oyunları getirme işlemini tetikler.
        viewModel.fetchFavoriteGames()
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoriteGames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Favori oyunları göstermek için koleksiyon hücresi oluşturma ve veriyle yapılandırma işlemleri.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as! FavoriteCell
        cell.configure(with: viewModel.favoriteGames[indexPath.item])
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let itemWidth: CGFloat = (collectionView.bounds.width - padding * 3) / 2
        let itemHeight: CGFloat = itemWidth * 0.9

        // Her hücrenin genişlik ve yükseklik boyutları belirlenir.
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Koleksiyon hücreleri arasındaki boşlukları ayarlamak için kenar boşlukları belirlenir.
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Koleksiyon hücreleri arasındaki satır aralıklarını belirlemek için minimum satır aralığı belirlenir.
        return 16
    }
}
