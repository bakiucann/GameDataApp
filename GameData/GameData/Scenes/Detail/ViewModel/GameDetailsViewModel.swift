//
//  GameDetailViewModel.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

// GameDetailViewModel.swift
// Bu dosya, oyun detaylarını görüntülemek için kullanılan view modeli içerir.

import Foundation

// GameDetailViewModelDelegate protokolü, oyun detaylarını almak için kullanılan işlemleri tanımlar.
protocol GameDetailViewModelDelegate: AnyObject {
    func gameDetailFetched()
    func gameDetailFetchFailed(with error: Error)
}

// GameDetailViewModel sınıfı, oyun detaylarını yönetmek ve görüntülemek için kullanılır.
class GameDetailViewModel {
    // NetworkManager ve CoreDataManager örneklerini sınıfa enjekte ederek bağımlılıkları azaltıyoruz.
    var networkManager: NetworkManagerProtocol = NetworkManager.shared
    var coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared

    // Oyun ve oyun detayı özelliklerini tanımlıyoruz.
    var game: Game
    var gameDetail: GameDetail?

    // Görünümü yeniden yüklemek için kapanma bloğunu tanımlıyoruz.
    var reloadView: (() -> Void)?
    // GameDetailViewModelDelegate delegesi, oyun detaylarını almak için kullanılan işlemleri yönetir.
    weak var delegate: GameDetailViewModelDelegate?

    // Oyun verisini alarak bir GameDetailViewModel örneği oluşturuyoruz.
    init(game: Game) {
        self.game = game
    }

    // Oyunu favorilere eklemek için kullanılan yöntemi tanımlıyoruz.
    func addToFavorites() {
        coreDataManager.addToFavorites(game: game)
    }

    // Oyunu favorilerden kaldırmak için kullanılan yöntemi tanımlıyoruz.
    func removeFromFavorites() {
        coreDataManager.removeFromFavorites(gameId: game.id)
    }

    // Oyunun favorilerde olup olmadığını kontrol eden yöntemi tanımlıyoruz.
    func isFavorite() -> Bool {
        return coreDataManager.isFavorite(gameId: game.id)
    }

    // Oyun detaylarını almak için kullanılan yöntemi tanımlıyoruz.
    func fetchGameDetail() {
        networkManager.getGameDetail(id: game.id) { [weak self] result in
            switch result {
            case .success(let gameDetail):
                self?.gameDetail = gameDetail
                // Görünümü güncellemek için reloadView kapanma bloğunu çağırıyoruz.
                self?.reloadView?()
                // GameDetailViewModelDelegate protokolündeki gameDetailFetched yöntemini çağırıyoruz.
                self?.delegate?.gameDetailFetched()
            case .failure(let error):
                print(error.localizedDescription)
                // GameDetailViewModelDelegate protokolündeki gameDetailFetchFailed yöntemini çağırıyoruz.
                self?.delegate?.gameDetailFetchFailed(with: error)
            }
        }
    }
}
