//
//  File.swift
//  GameDataTests
//
//  Created by Baki Uçan on 20.07.2023.
//

import XCTest
@testable import GameData

class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchGames() {
        // Test oyunları çekme işlemini simüle etmek için bir sahte NetworkManager oluşturuyoruz
        class MockNetworkManager: NetworkManagerProtocol {
            func getGames(completion: @escaping (Result<[Game], Error>) -> Void) {
                let games: [Game] = [
                    Game(id: 1, name: "Game 1", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil),
                    Game(id: 2, name: "Game 2", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil)
                ]
                completion(.success(games))
            }

            func getGameDetail(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {

            }
        }

        let mockNetworkManager = MockNetworkManager()
        viewModel.networkManager = mockNetworkManager

        let expectation = self.expectation(description: "Games fetched")

        viewModel.fetchGames()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Oyunları alıp almadığımızı kontrol ediyoruz ve beklentiyi gerçekleştiriyoruz
            XCTAssertFalse(self.viewModel.games.isEmpty)
            XCTAssertEqual(self.viewModel.games.count, 2)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFilterGames() {
        // Test için kullanılacak oyun listesini oluşturuyoruz
        let games: [Game] = [
            Game(id: 1, name: "Game 1", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil),
            Game(id: 2, name: "Game 2", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil),
            Game(id: 3, name: "Super Game", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil)
        ]

        viewModel.games = games

        // Boş bir arama metniyle filtreleme işlemini test ediyoruz
        viewModel.filterGames(with: "")
        XCTAssertEqual(viewModel.filteredGames.count, 3)

        // "game" ifadesi ile filtreleme işlemini test ediyoruz
        viewModel.filterGames(with: "game")
        XCTAssertEqual(viewModel.filteredGames.count, 3)

        // "super" ifadesi ile filtreleme işlemini test ediyoruz
        viewModel.filterGames(with: "super")
        XCTAssertEqual(viewModel.filteredGames.count, 1)
    }
}
