//
//  HomeView+UICollectionView.swift
//  GameData
//
//  Created by Baki Uçan on 14.07.2023.
//

import UIKit

// HomeViewController sınıfını UICollectionViewDataSource protokolü ile genişletir.
extension HomeViewController: UICollectionViewDataSource {
    // UICollectionViewDataSource protokolünden türetilen, koleksiyon görünümündeki hücre sayısını döndüren işlev.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // viewModel.filteredGames dizisinin eleman sayısını döndürür.
        // Eğer 0'dan küçükse, 0 olarak döndürürüz.
        return max(0, viewModel.filteredGames.count)
    }

    // UICollectionViewDataSource protokolünden türetilen, koleksiyon görünümündeki belirli bir hücreyi yapılandıran işlev.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Yeniden kullanılabilir GameCell hücresini alırız.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseIdentifier, for: indexPath) as! GameCell

        // indexPath'a göre, viewModel'den oyun verisini alırız ve hücreyi oyun verisi ile yapılandırırız.
        if let game = viewModel.game(for: indexPath, isSearching: isSearching) {
            cell.configure(with: game)
        }

        // Yapılandırılmış hücreyi döndürürüz.
        return cell
    }
}

// HomeViewController sınıfını UICollectionViewDelegateFlowLayout protokolü ile genişletir.
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout protokolünden türetilen, koleksiyon görünümündeki hücrelerin boyutunu belirten işlev.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Koleksiyon görünümünde hücrelerin yerleştirileceği alanı ayarlamak için kullanılacak genişlik ve yükseklik değerlerini hesaplarız.
        let padding: CGFloat = 16
        let itemWidth: CGFloat = (collectionView.bounds.width - padding * 3) / 2
        let itemHeight: CGFloat = itemWidth * 0.9

        // Hesaplanan boyutu döndürürüz.
        return CGSize(width: itemWidth, height: itemHeight)
    }

    // UICollectionViewDelegateFlowLayout protokolünden türetilen, koleksiyon görünümündeki hücrelerin iç kenar boşluğunu belirten işlev.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Koleksiyon görünümünde hücrelerin iç kenar boşluğunu belirleriz.
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    // UICollectionViewDelegateFlowLayout protokolünden türetilen, koleksiyon görünümündeki hücrelerin dikey aralığını belirten işlev.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Koleksiyon görünümündeki hücrelerin dikey aralığını belirleriz.
        return 16
    }
}
