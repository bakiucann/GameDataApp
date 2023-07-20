//
//  GameDetailViewModel.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import Foundation

// MARK: - GameDetailViewModelDelegate Protocol
protocol GameDetailViewModelDelegate: AnyObject {
    func gameDetailFetched()
    func gameDetailFetchFailed(with error: Error)
}

class GameDetailViewModel {
  var networkManager: NetworkManagerProtocol = NetworkManager.shared
  var coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared

    var game: Game
    var gameDetail: GameDetail?

    var reloadView: (() -> Void)?
    weak var delegate: GameDetailViewModelDelegate?

    init(game: Game) {
        self.game = game
    }

    func addToFavorites() {
        coreDataManager.addToFavorites(game: game)
    }

    func removeFromFavorites() {
        coreDataManager.removeFromFavorites(gameId: game.id)
    }

    func isFavorite() -> Bool {
        return coreDataManager.isFavorite(gameId: game.id)
    }

    func fetchGameDetail() {
        networkManager.getGameDetail(id: game.id) { [weak self] result in
            switch result {
            case .success(let gameDetail):
                self?.gameDetail = gameDetail
                self?.reloadView?()
                self?.delegate?.gameDetailFetched()
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.gameDetailFetchFailed(with: error)
            }
        }
    }
}
