//
//  File.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 05/06/2022.
//

import Foundation

struct GameDetail:Decodable {
    let id: Int?
    let name: String?
    let description: String?
    var backgroundImage: String?
    var redditUrl: String?
    var website: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, website
        case backgroundImage = "background_image"
        case redditUrl = "reddit_url"
        
    }
}

