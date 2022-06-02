//
//  GamesVC.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import Foundation
import UIKit
import Kingfisher

class GamesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var gameListVM: GameListViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Games"
        
        
    }
    

    
    func setUp() {
        let url = URL(string: "https://api.rawg.io/api/games?key=3be8af6ebf124ffe81d90f514e59856c&page_size=10&page=1")!
        APIService().getData(url: url) { games in
            if let games = games {
                self.gameListVM = GameListViewModel(games: games)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    // MARK: - TableView Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.gameListVM == nil ? 0 : self.gameListVM.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
        let gameVM = gameListVM.gameAtIndex(indexPath.row)
        cell.metacriticLabel.text = String(gameVM.metacritic!)
        cell.nameLabel.text = gameVM.name
        
        let imageUrl = URL(string: String(gameVM.backgroundImage!))
        cell.backgroundImageView.kf.indicatorType = .activity
        cell.backgroundImageView.kf.setImage(with: imageUrl)
        
        var result = [String]()
       
        
        
        gameVM.genres!.compactMap({ GenresItem in
            result.append(_: GenresItem.name!)
            
        })
       
        cell.ganresLabel.text = result.joined(separator: ", ")
  
        return cell
    }
    
}
