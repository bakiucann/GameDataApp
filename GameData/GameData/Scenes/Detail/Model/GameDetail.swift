//
//  GameDetail.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import Foundation

struct GameDetail: Codable {
    let id: Int
    let name: String
    let descriptionRaw: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let developers: [Developer]?
    let metacritic: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionRaw = "description_raw"
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case developers
        case metacritic
    }
}

struct Developer: Codable {
    let id: Int
    let name: String
}
