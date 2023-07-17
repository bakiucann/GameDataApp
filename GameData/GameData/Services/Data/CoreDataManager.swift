//
//  CoreDataManager.swift
//  GameData
//
//  Created by Baki Uçan on 14.07.2023.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

  func addToFavorites(game: Game) {
      let favorite = FavoriteGame(context: viewContext)
      favorite.gameId = Int32(game.id)
      favorite.name = game.name
      favorite.backgroundImage = game.backgroundImage
      favorite.rating = game.rating ?? 0
      saveContext()
  }


    func removeFromFavorites(gameId: Int) {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameId == %d", gameId)

        do {
            let favorites = try viewContext.fetch(fetchRequest)
            for favorite in favorites {
                viewContext.delete(favorite)
            }
            saveContext()
        } catch {
            print("Error removing favorite: \(error.localizedDescription)")
        }
    }

    func isFavorite(gameId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameId == %d", gameId)

        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite: \(error.localizedDescription)")
            return false
        }
    }

  func fetchFavoriteGames() -> [Game] {
      let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()

      do {
          let favorites = try viewContext.fetch(fetchRequest)
          let games = favorites.map { favorite -> Game in
              return Game(id: Int(favorite.gameId), name: favorite.name ?? "", released: nil, backgroundImage: favorite.backgroundImage, rating: favorite.rating, ratingTop: nil)
          }
          return games
      } catch {
          print("Error fetching favorite games: \(error.localizedDescription)")
          return []
      }
  }


    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
}
