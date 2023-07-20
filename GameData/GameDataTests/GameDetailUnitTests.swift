//
//  GameDetailTests.swift
//  GameDataTests
//
//  Created by Baki Uçan on 20.07.2023.
//

import XCTest
@testable import GameData

class GameDetailViewModelTests: XCTestCase {

    var viewModel: GameDetailViewModel!

    override func setUpWithError() throws {
        // Test verileriyle bir GameDetailViewModel örneği oluşturuyoruz
        let game = Game(id: 1, name: "Test Game", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil)
        viewModel = GameDetailViewModel(game: game)
    }

    override func tearDownWithError() throws {
        // Test tamamlandığında viewModel'i temizliyoruz
        viewModel = nil
    }

    func testAddToFavorites() {
        // addToFavorites() metodunun çağrılıp çağrılmadığını kontrol etmek için MockCoreDataManager kullanıyoruz
        class MockCoreDataManager: CoreDataManagerProtocol {
            var addToFavoritesCalled = false

            func addToFavorites(game: Game) {
                addToFavoritesCalled = true
            }

            func removeFromFavorites(gameId: Int) {

            }

            func isFavorite(gameId: Int) -> Bool {

                return false
            }

            func fetchFavoriteGames() -> [Game] {

                return []
            }
        }

        let mockCoreDataManager = MockCoreDataManager()
        viewModel.coreDataManager = mockCoreDataManager

        // addToFavorites() metodunu çağırıyoruz ve mockCoreDataManager.addToFavoritesCalled değişkenini kontrol ediyoruz
        viewModel.addToFavorites()
        XCTAssertTrue(mockCoreDataManager.addToFavoritesCalled)
    }

    func testRemoveFromFavorites() {
        // removeFromFavorites() metodunun çağrılıp çağrılmadığını kontrol etmek için MockCoreDataManager kullanıyoruz
        class MockCoreDataManager: CoreDataManagerProtocol {
            var removeFromFavoritesCalled = false

            func addToFavorites(game: Game) {

            }

            func removeFromFavorites(gameId: Int) {
                removeFromFavoritesCalled = true
            }

            func isFavorite(gameId: Int) -> Bool {

                return false
            }

            func fetchFavoriteGames() -> [Game] {

                return []
            }
        }

        let mockCoreDataManager = MockCoreDataManager()
        viewModel.coreDataManager = mockCoreDataManager

        // removeFromFavorites() metodunu çağırıyoruz ve mockCoreDataManager.removeFromFavoritesCalled değişkenini kontrol ediyoruz
        viewModel.removeFromFavorites()
        XCTAssertTrue(mockCoreDataManager.removeFromFavoritesCalled)
    }

    func testIsFavorite() {
        // isFavorite() metodunu test etmek için MockCoreDataManager kullanıyoruz ve isFavoriteValue değişkenini true olarak ayarlıyoruz
        class MockCoreDataManager: CoreDataManagerProtocol {
            var isFavoriteValue = true

            func addToFavorites(game: Game) {

            }

            func removeFromFavorites(gameId: Int) {

            }

            func isFavorite(gameId: Int) -> Bool {
                return isFavoriteValue
            }

            func fetchFavoriteGames() -> [Game] {

                return []
            }
        }

        let mockCoreDataManager = MockCoreDataManager()
        viewModel.coreDataManager = mockCoreDataManager

        // isFavorite() metodunu çağırıyoruz ve geri dönen değerin mockCoreDataManager'deki isFavoriteValue ile eşleştiğini kontrol ediyoruz
        XCTAssertTrue(viewModel.isFavorite())
    }

    func testFetchGameDetail() {
        // fetchGameDetail() metodunu test etmek için MockNetworkManager kullanıyoruz ve önceden tanımlı bir game detail döndürüyoruz
        class MockNetworkManager: NetworkManagerProtocol {
            func getGames(completion: @escaping (Result<[Game], Error>) -> Void) {

            }

            func getGameDetail(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {
                let gameDetail = GameDetail(id: 1, name: "Test Game", descriptionRaw: nil, released: nil, backgroundImage: nil, rating: nil, ratingTop: nil, developers: nil, metacritic: nil)
                completion(.success(gameDetail))
            }
        }

        let mockNetworkManager = MockNetworkManager()
        viewModel.networkManager = mockNetworkManager

        // Asenkron fetchGameDetail() çağrısını beklemek için bir expectation oluşturuyoruz
        let expectation = self.expectation(description: "Game detail fetched")

        // fetchGameDetail() metodunu çağırıyoruz ve gameDetail özelliğinin nil olmadığını kontrol ediyoruz
        viewModel.fetchGameDetail()

        // Asenkron fetchGameDetail() tamamlanana kadar bekliyoruz
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.viewModel.gameDetail)
            expectation.fulfill()
        }

        // expectation'un gerçekleşmesini bekliyoruz
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchGameDetailFailure() {
        // fetchGameDetail() metodunun hata durumunu test etmek için MockNetworkManager kullanıyoruz ve bir hata döndürüyoruz
        class MockNetworkManager: NetworkManagerProtocol {
            func getGames(completion: @escaping (Result<[Game], Error>) -> Void) {

            }

            func getGameDetail(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {
                completion(.failure(NSError(domain: "TestErrorDomain", code: 1234, userInfo: nil)))
            }
        }

        let mockNetworkManager = MockNetworkManager()
        viewModel.networkManager = mockNetworkManager

        // Asenkron fetchGameDetail() çağrısını beklemek için bir expectation oluşturuyoruz
        let expectation = self.expectation(description: "Game detail fetch failed")

        // Hata durumunu yakalamak için MockDelegate kullanıyoruz
        class MockDelegate: GameDetailViewModelDelegate {
            var error: Error?
            func gameDetailFetched() {}
            func gameDetailFetchFailed(with error: Error) {
                self.error = error
            }
        }

        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate

        // fetchGameDetail() metodunu çağırıyoruz ve hata durumunun mockDelegate'de yakalandığını kontrol ediyoruz
        viewModel.fetchGameDetail()

        // Asenkron fetchGameDetail() tamamlanana kadar bekliyoruz
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(mockDelegate.error)
            expectation.fulfill()
        }

        // expectation'un gerçekleşmesini bekliyoruz
        waitForExpectations(timeout: 5, handler: nil)
    }
}
