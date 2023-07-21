//
//  HomeViewModel.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import Foundation

// Ana Sayfa Görünüm Modelini uygulayan bir protokol tanımlıyoruz.
protocol HomeViewModelProtocol {
    var games: [Game] { get }
    var filteredGames: [Game] { get }
    var reloadCollectionView: (() -> Void)? { get set }
    func fetchGames()
    func filterGames(with searchText: String)
}

// Ana Sayfa Görünüm Modeli sınıfını oluşturuyoruz.
class HomeViewModel {
    // NetworkManager'ı tanımlıyoruz. Bu, oyun verilerini almak için kullanılacak.
    var networkManager: NetworkManagerProtocol = NetworkManager.shared

    // Tüm oyunları tutacak bir dizi tanımlıyoruz.
    var games: [Game] = []

    // Filtrelenmiş oyunları tutacak bir dizi tanımlıyoruz.
    var filteredGames: [Game] = []

    // Koleksiyon görünümünü güncellemek için kapatma bloğunu tanımlıyoruz.
    var reloadCollectionView: (() -> Void)?

    // Oyun verilerini alacak olan yöntemi tanımlıyoruz.
    func fetchGames() {
        networkManager.getGames { [weak self] result in
            switch result {
            case .success(let games):
                // Oyunları güncelliyoruz ve koleksiyon görünümünü güncellemek için kapatma bloğunu çağırıyoruz.
                self?.games = games
                self?.filteredGames = games
                self?.reloadCollectionView?()
            case .failure(let error):
                // Hata durumunda hata mesajını yazdırıyoruz.
                print(error.localizedDescription)
            }
        }
    }

    // Oyunları filtrelemek için yöntemi tanımlıyoruz.
    func filterGames(with searchText: String) {
        if searchText.isEmpty {
            // Eğer arama çubuğu boşsa, filtrelenmiş oyunları tüm oyunlarla eşitliyoruz.
            filteredGames = games
        } else {
            // Eğer arama çubuğu doluysa, filtreleme işlemini gerçekleştiriyoruz.
            filteredGames = games.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        // Koleksiyon görünümünü güncellemek için kapatma bloğunu çağırıyoruz.
        reloadCollectionView?()
    }

    // IndexPath'e göre oyunları getiren yöntemi tanımlıyoruz.
    func game(for indexPath: IndexPath, isSearching: Bool) -> Game? {
        // Filtreleme işlemi yapıldıysa, indexPath'ı düzenlememiz gerekecek.
        let adjustedIndex = isSearching ? indexPath.item : indexPath.item + 3
        // Düzenlenen index, filtrelenmiş oyunlar dizisi içinde geçerliyse, oyunu döndürüyoruz.
        if adjustedIndex >= 0 && adjustedIndex < filteredGames.count {
            return filteredGames[adjustedIndex]
        }
        // Geçerli bir oyun bulunamadığında nil döndürüyoruz.
        return nil
    }
}
