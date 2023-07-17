//
//  FavoritesViewModel.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

// FavoritesViewModel.swift

import Foundation

class FavoritesViewModel {
    private let coreDataManager = CoreDataManager.shared
    var favoriteGames: [Game] = []

    var reloadTableView: (() -> Void)?

    init() {
        fetchFavoriteGames()
    }

    func fetchFavoriteGames() {
        favoriteGames = coreDataManager.fetchFavoriteGames()
        reloadTableView?()
    }

    func removeFavorite(game: Game) {
        coreDataManager.removeFromFavorites(gameId: game.id)
        fetchFavoriteGames()
    }
}
