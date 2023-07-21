//
//  NetworkManager.swift
//
//
//  Created by Baki Uçan on 11.07.2023.
//

import Foundation

// NetworkManagerProtocol, API'den oyun verilerini almak için gereken işlevleri içerir.
protocol NetworkManagerProtocol {
    func getGames(completion: @escaping (Result<[Game], Error>) -> Void)
    func getGameDetail(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void)
}

// NetworkManager sınıfı, NetworkManagerProtocol'ü uygular ve oyun verilerini almak için gerekli işlevleri sağlar.
class NetworkManager: NetworkManagerProtocol {
    // Singleton tasarım deseni uyarınca NetworkManager sınıfı için paylaşılan tek bir örnek oluşturulur.
    static let shared = NetworkManager()

    private init() {}

    // API'den oyun verilerini almak için işlev.
    func getGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/games?key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else { return }

        // URL'den verileri alma işlemi başlatılır.
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                // API yanıtını oyun modeline dönüştürme.
                let gamesResponse = try JSONDecoder().decode(GamesResponse.self, from: data)
                completion(.success(gamesResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // API'den belirli bir oyunun ayrıntılarını almak için işlev.
    func getGameDetail(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/games/\(id)?key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else { return }

        // URL'den verileri alma işlemi başlatılır.
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                // API yanıtını oyun ayrıntıları modeline dönüştürme.
                let gameDetail = try JSONDecoder().decode(GameDetail.self, from: data)
                completion(.success(gameDetail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
