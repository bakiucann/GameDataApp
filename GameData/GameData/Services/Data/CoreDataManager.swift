//
//  CoreDataManager.swift
//  GameData
//
//  Created by Baki Uçan on 14.07.2023.
//

import CoreData

// CoreDataManagerProtocol, CoreDataManager sınıfı için bir protokoldür ve temel işlevleri tanımlar.
protocol CoreDataManagerProtocol {
    // Favorilere oyun eklemek için kullanılacak işlev.
    func addToFavorites(game: Game)

    // Favorilerden oyun çıkarmak için kullanılacak işlev.
    func removeFromFavorites(gameId: Int)

    // Belirli bir oyunun favori olup olmadığını kontrol etmek için kullanılacak işlev.
    func isFavorite(gameId: Int) -> Bool

    // Favori oyunları getirmek için kullanılacak işlev.
    func fetchFavoriteGames() -> [Game]
}

// CoreDataManager, CoreDataManagerProtocol'ü uygulayan ana veri yöneticisi sınıfıdır.
class CoreDataManager: CoreDataManagerProtocol {
    // Singleton tasarım desenine uygun şekilde, CoreDataManager'ın bir tek örneği paylaşılabilir.
    static let shared = CoreDataManager()

    // private init, CoreDataManager sınıfının başka bir yerden örneklenmesini engeller.
    private init() {}

    // CoreData için ana yönetici sınıfıdır. Veritabanı işlemleri için kullanılacak.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Çözülememiş hata \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // CoreData veri değişikliklerini görüntülemek ve gerçekleştirmek için kullanılacak olan görünüm bağlamıdır.
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Favorilere oyun eklemek için kullanılan işlev.
    func addToFavorites(game: Game) {
        // CoreData'da yeni bir FavoriteGame nesnesi oluşturulur ve Game verileri ile doldurulur.
        let favorite = FavoriteGame(context: viewContext)
        favorite.gameId = Int32(game.id)
        favorite.name = game.name
        favorite.backgroundImage = game.backgroundImage
        favorite.rating = game.rating ?? 0
        saveContext() // Veritabanındaki değişiklikleri kaydetmek için saveContext() çağrılır.
    }

    // Favorilerden oyun çıkarmak için kullanılan işlev.
    func removeFromFavorites(gameId: Int) {
        // Silinecek oyunu belirlemek için gameId ile eşleşen FavoriteGame nesnesi aranır.
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameId == %d", gameId)

        do {
            // Oyun bulunur ve silinir.
            let favorites = try viewContext.fetch(fetchRequest)
            for favorite in favorites {
                viewContext.delete(favorite)
            }
            saveContext() // Veritabanındaki değişiklikleri kaydetmek için saveContext() çağrılır.
        } catch {
            print("Favori çıkarma hatası: \(error.localizedDescription)")
        }
    }

    // Belirli bir oyunun favori olup olmadığını kontrol etmek için kullanılan işlev.
    func isFavorite(gameId: Int) -> Bool {
        // gameId ile eşleşen FavoriteGame nesnesinin varlığını kontrol ederiz.
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameId == %d", gameId)

        do {
            // Oyun bulunur ve sayısı hesaplanır.
            let count = try viewContext.count(for: fetchRequest)
            return count > 0 // Sayı 0'dan büyükse, oyun favoridir ve true döner.
        } catch {
            print("Favori kontrol hatası: \(error.localizedDescription)")
            return false
        }
    }

    // Favori oyunları getirmek için kullanılan işlev.
    func fetchFavoriteGames() -> [Game] {
        // CoreData'dan tüm FavoriteGame nesnelerini alırız.
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()

        do {
            // Tüm nesneler Game nesnelerine dönüştürülür ve bir dizi olarak döndürülür.
            let favorites = try viewContext.fetch(fetchRequest)
            let games = favorites.map { favorite -> Game in
                return Game(id: Int(favorite.gameId), name: favorite.name ?? "", released: nil, backgroundImage: favorite.backgroundImage, rating: favorite.rating, ratingTop: nil)
            }
            return games
        } catch {
            print("Favori oyunları getirme hatası: \(error.localizedDescription)")
            return []
        }
    }

    // Veritabanındaki değişiklikleri kaydetmek için kullanılan özel işlev.
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Bağlamı kaydetme hatası: \(error.localizedDescription)")
            }
        }
    }
}
