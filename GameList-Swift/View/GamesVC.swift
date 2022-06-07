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
    
    var myClicked = UserDefaults.standard.array(forKey: "tappedGames") as? [Int] ?? []
    
    var currentPage = 4
    var pageSize = 10
    var apiKey = "3be8af6ebf124ffe81d90f514e59856c"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        self.tableView.reloadData()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Games"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myClicked = UserDefaults.standard.array(forKey: "tappedGames") as? [Int] ?? []
        self.tableView.reloadData()
    }
    
    
    
    func setUp() {
        let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKey)&page_size=\(pageSize)&page=\(currentPage)")!
        APIService().getData(url: url) { games in
            if let games = games {
                self.gameListVM = GameListViewModel(games: games)
                DispatchQueue.main.async {
                    if self.currentPage == 4 {
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }
        print("setup called")
        print(currentPage)
        print("clicked arrray: \(myClicked)")
        
    }
    
    func fetchNextPage(){
        currentPage += 1
        setUp()
        
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
        
        if let imagePath = gameVM.backgroundImage {
            if let imageURL = URL(string: imagePath) {
                cell.backgroundImageView.kf.indicatorType = .activity
                cell.backgroundImageView.kf.setImage(with: imageURL)
            }
        }
        
        if let metaCritic = gameVM.metacritic {
            cell.metacriticLabel.text = String(metaCritic) 
        }
        
        if let gameName = gameVM.name {
            cell.nameLabel.text = gameName
        }

        if let gameGenres = gameVM.genres {
            var result = [String]()
            gameGenres.forEach { GenresItem in
                if let genresName = GenresItem.name {
                    result.append(_: genresName)
                    cell.ganresLabel.text = result.joined(separator: ", ")
                }
            }
        }

        myClicked.forEach { clickedId in
            if gameVM.id == clickedId {
                cell.backgroundColor = UIColor(red: 0.879, green: 0.879, blue: 0.879, alpha: 1)
            }
        }

        return cell
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let intTotalRow = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == intTotalRow - 1 {
            if intTotalRow % 10 == 0 {
                fetchNextPage()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailsVC = segue.destination as! GameDetailsVC
        let selectedRow = tableView.indexPathForSelectedRow!.row
        detailsVC.receivedData = gameListVM.gameAtIndex(selectedRow).id!
        
        let userDefaults = UserDefaults.standard
        var strings: [Int] = userDefaults.object(forKey: "tappedGames") as? [Int] ?? []
        strings.append(detailsVC.receivedData)
        userDefaults.set(strings, forKey: "tappedGames")
        
        print("clicked id: \(strings)")
        
    }
    
}
