//
//  GameList.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import Foundation

struct GameList: Decodable {
    var results: [Game]
}

struct Game: Decodable {
    
    var id: Int?
    var name: String?
    var metacritic: Int?
    var background_image: String?
//    var backgroundImage: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case backgroundImage = "background_image"
//    }
}



