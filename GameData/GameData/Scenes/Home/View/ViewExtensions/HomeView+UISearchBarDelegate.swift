//
//  HomeView+UISearchBarDelegate.swift
//  GameData
//
//  Created by Baki Uçan on 17.07.2023.
//

import UIKit

// HomeViewController sınıfını UISearchBarDelegate protokolü ile genişletir.
extension HomeViewController: UISearchBarDelegate {
    // UISearchBarDelegate protokolünden türetilen, arama çubuğundaki metin değiştiğinde çağrılan işlev.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Arama çubuğunda yazılan metin boşsa, arama yapılmıyor olarak işaretle ve tüm oyunları gösteririz.
        // Eğer metin uzunluğu en az 3 ise, arama yapılıyor olarak işaretle ve oyunları filtreleriz.
        if searchText.isEmpty {
            isSearching = false
            viewModel.filterGames(with: "")
        } else if searchText.count >= 3 {
            isSearching = true
            viewModel.filterGames(with: searchText)
        }
        // Boş durum ekranını günceller ve koleksiyon görünümünü yeniden yükleriz.
        handleEmptyState()
        collectionView.reloadData()
    }

    // UISearchBarDelegate protokolünden türetilen, arama çubuğu düzenleme işlemi başladığında çağrılan işlev.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Arama çubuğu düzenleme işlemine başladığında koleksiyon görünümünün üst kenar bağlayıcısını güncelleriz.
        // Böylece arama çubuğu düzenleme işlemi sırasında koleksiyon görünümü arama çubuğunun üzerinde yer alır.
        collectionViewTopConstraint?.isActive = false
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        collectionViewTopConstraint?.isActive = true
        searchBar.showsCancelButton = true

        // Animasyonlu olarak güncelleme işlemlerini yaparız.
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    // UISearchBarDelegate protokolünden türetilen, arama çubuğu düzenleme işlemi sona erdiğinde çağrılan işlev.
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Arama çubuğu düzenleme işlemi sona erdiğinde "Cancel" butonunu gizleriz.
        searchBar.showsCancelButton = false
    }

    // UISearchBarDelegate protokolünden türetilen, arama çubuğunda "Search" düğmesine tıklandığında çağrılan işlev.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // "Search" düğmesine tıklandığında, arama çubuğundaki metni kullanarak oyunları filtreleriz.
        if let searchText = searchBar.text {
            viewModel.filterGames(with: searchText)
        }
    }

    // UISearchBarDelegate protokolünden türetilen, arama çubuğundaki "Cancel" düğmesine tıklandığında çağrılan işlev.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // "Cancel" düğmesine tıklandığında, arama çubuğunu temizler ve ilk haliyle geri getiririz.
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()

        // Koleksiyon görünümünün üst kenar bağlayıcısını güncelleriz ve koleksiyon görünümünü yeniden yükleriz.
        collectionViewTopConstraint?.isActive = false
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor)
        collectionViewTopConstraint?.isActive = true

        // Animasyonlu olarak güncelleme işlemlerini yaparız.
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }

        // Oyunları filtreleriz ve koleksiyon görünümünü yeniden yükleriz.
        viewModel.filterGames(with: "")
        collectionView.reloadData()
        isSearching = false
        // Boş durum ekranını güncelleriz.
        handleEmptyState()
    }
}
