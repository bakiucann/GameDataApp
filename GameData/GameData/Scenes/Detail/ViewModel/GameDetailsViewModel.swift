//
//  GameDetailViewModel.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

// GameDetailViewModel.swift

import Foundation

class GameDetailViewModel {
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared

    var game: Game
    var gameDetail: GameDetail?

    var reloadView: (() -> Void)?

    init(game: Game) {
        self.game = game
    }

  func addToFavorites() {
      print(game)
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
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
