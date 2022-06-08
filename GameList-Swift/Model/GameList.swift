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

struct GenresItem: Decodable{
    var id: Int?
    var name: String?
}

struct Game: Decodable {
    var id: Int?
    var name: String?
    var metacritic: Int?
    var backgroundImage: String?
    var genres: [GenresItem]
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, metacritic, genres
        case backgroundImage = "background_image"
        
    }
}





