//
//  GameListViewModel.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import Foundation

struct GameListViewModel {
    let games: [Game]
}

extension GameListViewModel {
    var numberOfSections: Int {
        return games.count
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
    
    var name: String? {
        return self.game.name
    }
    
    var metacritic: Int? {
        return self.game.metacritic
    }
   
}
