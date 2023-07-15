//
//  APIManager.swift
//
//
//  Created by Baki Uçan on 11.07.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "https://api.rawg.io/api"
    private let apiKey = "e018dd6c0746498c90843c6a97158425"

    private init() {}

    func getGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        let urlString = "\(baseURL)/games?key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let gamesResponse = try JSONDecoder().decode(GamesResponse.self, from: data)
                completion(.success(gamesResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func getGameDetail(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {
        let urlString = "\(baseURL)/games/\(id)?key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let gameDetail = try JSONDecoder().decode(GameDetail.self, from: data)
                completion(.success(gameDetail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct GamesResponse: Codable {
    let results: [Game]
}
