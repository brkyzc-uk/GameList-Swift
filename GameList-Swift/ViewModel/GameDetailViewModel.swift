//
//  GameDetailViewModel.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 05/06/2022.
//

import Foundation


struct GameDetailViewModel {
    let gameDetails: GameDetail
}

extension GameDetailViewModel {
    init(_ gameDetails: GameDetail) {
        self.gameDetails = gameDetails
    }
}

extension GameDetailViewModel {
    var id: Int? {
        return self.gameDetails.id
    }
    
    var name: String? {
        return self.gameDetails.name
    }
    
    var description: String? {
        return self.gameDetails.description
    }
    
    var backgroundImage: String? {
        return self.gameDetails.backgroundImage
    }
    
    var redditUrl: String? {
        return self.gameDetails.redditUrl
    }
    
    var website: String? {
        return self.gameDetails.website
    }
    
    var metaCritic: Int? {
        return self.gameDetails.metacritic
    }
    
    var genres: [GenresItem]? {
        return self.gameDetails.genres
    }

}


