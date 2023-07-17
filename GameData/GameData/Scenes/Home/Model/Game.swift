//
//  Game.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

// Game.swift

import Foundation

struct Game: Codable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
    }
}
