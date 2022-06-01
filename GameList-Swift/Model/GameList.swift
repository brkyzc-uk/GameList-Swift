//
//  GameList.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import Foundation

struct GameList: Decodable {
    let results: [Game]
}

struct Game: Decodable {
    
    var name: String?
    var metacritic: Int?
    
}
