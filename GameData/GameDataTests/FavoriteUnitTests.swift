//
//  FavoriteUnitTests.swift
//  GameDataTests
//
//  Created by Baki Uçan on 20.07.2023.
//

import XCTest
@testable import GameData

class FavoritesViewModelTests: XCTestCase {

    var viewModel: FavoritesViewModel!

    // Testler başlamadan önce çalışacak hazırlık fonksiyonu
    override func setUpWithError() throws {
        // Favoriler Görünüm Modelini oluştur
        viewModel = FavoritesViewModel()
    }

    // Testler tamamlandıktan sonra çalışacak temizlik fonksiyonu
    override func tearDownWithError() throws {
        // Favoriler Görünüm Modelini temizle
        viewModel = nil
    }

    // Favori oyunları getirme işlevini test etmek için test fonksiyonu
    func testFetchFavoriteGames() {
        // Favori oyunları sağlayan sahte CoreDataManager oluştur
        class MockCoreDataManager: CoreDataManagerProtocol {
            // Sahte veritabanı oyunlar listesi
            var favoriteGames: [Game] = [
                Game(id: 1, name: "Favori Oyun 1", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil),
                Game(id: 2, name: "Favori Oyun 2", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil)
            ]

            // Favori oyunu veritabanına ekleme işlevi (bu testte kullanılmaz)
            func addToFavorites(game: Game) {

            }

            // Favori oyunu veritabanından kaldırma işlevi (bu testte kullanılır)
            func removeFromFavorites(gameId: Int) {

                favoriteGames = favoriteGames.filter { $0.id != gameId }
            }

            // Bir oyunun favori olup olmadığını kontrol etme işlevi (bu testte kullanılmaz)
            func isFavorite(gameId: Int) -> Bool {

                return favoriteGames.contains { $0.id == gameId }
            }

            // Favori oyunları veritabanından getirme işlevi (bu testte kullanılır)
            func fetchFavoriteGames() -> [Game] {

                return favoriteGames
            }
        }

        // Favori oyunları sağlayan sahte CoreDataManager'ı oluştur
        let mockCoreDataManager = MockCoreDataManager()
        viewModel.coreDataManager = mockCoreDataManager

        // Favori oyunları getirme işlevini çağır ve favoriteGames dizisinin boş olmadığını ve doğru sayıda oyun içerdiğini kontrol et
        viewModel.fetchFavoriteGames()

        XCTAssertFalse(viewModel.favoriteGames.isEmpty)
        XCTAssertEqual(viewModel.favoriteGames.count, 2)
    }

    // Favori oyunu kaldırma işlevini test etmek için test fonksiyonu
    func testRemoveFavorite() {
        // Favori oyunu kaldırma işlevinin çağrılıp çağrılmadığını kontrol etmek için sahte CoreDataManager oluştur
        class MockCoreDataManager: CoreDataManagerProtocol {
            // removeFavoriteCalled, removeFromFavorites işlevinin çağrılıp çağrılmadığını saklayan bir işaretçi
            var removeFavoriteCalled = false
            // Sahte veritabanı oyunlar listesi
            var favoriteGames: [Game] = [
                Game(id: 1, name: "Favori Oyun 1", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil),
                Game(id: 2, name: "Favori Oyun 2", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil)
            ]

            // Favori oyunu veritabanına ekleme işlevi (bu testte kullanılmaz)
            func addToFavorites(game: Game) {

            }

            // Favori oyunu veritabanından kaldırma işlevi (bu testte kullanılır)
            func removeFromFavorites(gameId: Int) {

                removeFavoriteCalled = true
                favoriteGames = favoriteGames.filter { $0.id != gameId }
            }

            // Bir oyunun favori olup olmadığını kontrol etme işlevi (bu testte kullanılmaz)
            func isFavorite(gameId: Int) -> Bool {

                return favoriteGames.contains { $0.id == gameId }
            }

            // Favori oyunları veritabanından getirme işlevi (bu testte kullanılmaz)
            func fetchFavoriteGames() -> [Game] {

                return favoriteGames
            }
        }

        // Favori oyunları sağlayan sahte CoreDataManager'ı oluştur
        let mockCoreDataManager = MockCoreDataManager()
        viewModel.coreDataManager = mockCoreDataManager

        // Test için bir oyun örneği hazırla
        let game = Game(id: 1, name: "Test Oyunu", released: nil, backgroundImage: nil, rating: nil, ratingTop: nil)

        // Favori oyunu kaldırma işlevini çağır ve mockCoreDataManager.removeFavoriteCalled değerinin true olup olmadığını kontrol et
        viewModel.removeFavorite(game: game)
        XCTAssertTrue(mockCoreDataManager.removeFavoriteCalled)

        // Oyunun favoriteGames dizisinden çıkarıldığını kontrol et
        XCTAssertFalse(viewModel.favoriteGames.contains { $0.id == game.id })
    }
}
