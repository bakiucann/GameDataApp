//
//  GameDataTests.swift
//  GameDataTests
//
//  Created by Baki Uçan on 11.07.2023.
//

import XCTest
@testable import GameData

class GameDataTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    var gameDetailViewModel: GameDetailViewModel!
    var favoritesViewModel: FavoritesViewModel!

    override func setUp() {
        super.setUp()
        homeViewModel = HomeViewModel()
        gameDetailViewModel = GameDetailViewModel(game: Game(id: 1, name: "Test Game", released: "2023-07-11", backgroundImage: nil, rating: nil, ratingTop: nil))
        favoritesViewModel = FavoritesViewModel()
    }

    override func tearDown() {
        homeViewModel = nil
        gameDetailViewModel = nil
        favoritesViewModel = nil
        super.tearDown()
    }

    func testHomeViewModelFetchGames() {
        let expectation = self.expectation(description: "Fetch Games")
        homeViewModel.reloadCollectionView = {
            expectation.fulfill()
        }
        homeViewModel.fetchGames()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(homeViewModel.games.isEmpty)
    }

    func testHomeViewModelFilterGames() {
        homeViewModel.games = [Game(id: 1, name: "Test Game", released: "2023-07-11", backgroundImage: nil, rating: nil, ratingTop: nil)]
        homeViewModel.filterGames(with: "Test")
        XCTAssertEqual(homeViewModel.filteredGames.count, 1)
    }

    func testGameDetailViewModelFetchGameDetail() {
        let expectation = self.expectation(description: "Fetch Game Detail")
        gameDetailViewModel.delegate = self
        gameDetailViewModel.reloadView = {
            expectation.fulfill()
        }
        gameDetailViewModel.fetchGameDetail()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(gameDetailViewModel.gameDetail)
    }

    func testFavoritesViewModelFetchFavoriteGames() {
        favoritesViewModel.fetchFavoriteGames()
        XCTAssertNotNil(favoritesViewModel.favoriteGames)
    }
}

extension GameDataTests: GameDetailViewModelDelegate {
    func gameDetailFetched() {}
    func gameDetailFetchFailed(with error: Error) {}
}
