//
//  GameListViewModel.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import Foundation
import UIKit

struct GameListViewModel {
    let games: [Game]
}

extension GameListViewModel {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return games.count
    }
    
    func gameAtIndex(_ index: Int) -> GameViewModel {
        let game = self.games[index]
        return GameViewModel(game)
    }
    
    
}

struct GameViewModel {
    private let game: Game
}


extension GameViewModel {
    init(_ game: Game) {
        self.game = game
    }
}

extension GameViewModel {
    var id: Int? {
        return self.game.id
    }
    
    var name: String? {
        return self.game.name
    }
    
    var metacritic: Int? {
        return self.game.metacritic
    }
    
    var backgroundImage: String? {
        return self.game.backgroundImage
    }
    
    var genres: [GenresItem]? {
        return self.game.genres
    }
    
    

}
