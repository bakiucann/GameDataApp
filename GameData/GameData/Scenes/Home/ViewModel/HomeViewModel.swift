//
//  HomeViewModel.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var games: [Game] { get }
    var filteredGames: [Game] { get }
    var reloadCollectionView: (() -> Void)? { get set }
    func fetchGames()
    func filterGames(with searchText: String)
}

class HomeViewModel {
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
    var games: [Game] = []
    var filteredGames: [Game] = []

    var reloadCollectionView: (() -> Void)?

    func fetchGames() {
        networkManager.getGames { [weak self] result in
            switch result {
            case .success(let games):
                self?.games = games
                self?.filteredGames = games
                self?.reloadCollectionView?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

  func filterGames(with searchText: String) {
      if searchText.isEmpty {
          filteredGames = games
      } else {
          filteredGames = games.filter { $0.name.lowercased().contains(searchText.lowercased()) }
      }
      reloadCollectionView?()
  }
}
