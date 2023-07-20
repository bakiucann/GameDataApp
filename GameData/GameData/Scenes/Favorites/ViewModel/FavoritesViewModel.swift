//
//  FavoritesViewModel.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import Foundation

// MARK: - FavoritesViewModelDelegate Protocol
protocol FavoritesViewModelDelegate: AnyObject {
    func favoriteGamesFetched()
    func favoriteGamesFetchFailed(with error: Error)
}

class FavoritesViewModel {
   var coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
    var favoriteGames: [Game] = []

    var reloadTableView: (() -> Void)?
    weak var delegate: FavoritesViewModelDelegate?

    init() {
        fetchFavoriteGames()
    }

    func fetchFavoriteGames() {
        favoriteGames = coreDataManager.fetchFavoriteGames()
        reloadTableView?()
        delegate?.favoriteGamesFetched()
    }

    func removeFavorite(game: Game) {
        coreDataManager.removeFromFavorites(gameId: game.id)
        fetchFavoriteGames()
    }
}
