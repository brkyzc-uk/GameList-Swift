//
//  GamesVC.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import Foundation
import UIKit
import Kingfisher

class GamesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private var gameListVM: GameListViewModel!
    
    var myClicked = UserDefaults.standard.array(forKey: "tappedGames") as? [Int] ?? []
    
    var latestSearchedText: String = ""
    var currentPage = 1
    var pageSize = 10
    var apiKey = "3be8af6ebf124ffe81d90f514e59856c"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delete User Data
        //        UserDefaults.standard.removeObject(forKey: "favGameIds")
        //        UserDefaults.standard.removeObject(forKey: "favGameNames")
        //        UserDefaults.standard.removeObject(forKey: "favGameImages")
        //        UserDefaults.standard.removeObject(forKey: "favMetaCritics")
        //        UserDefaults.standard.removeObject(forKey: "favGameGenres")
        //        UserDefaults.standard.removeObject(forKey: "tappedGames")
        
        self.gameListVM = GameListViewModel(games: [])
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
        APIService().getData(url: url) { [weak self] games in
            guard let self = self else { return }
            if let games = games {
                if self.currentPage == 1 {
                    self.gameListVM.games = games
                } else {
                    self.gameListVM.games.append(contentsOf: games)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchNextPage(){
        currentPage += 1
        
        if latestSearchedText == "" {
            setUp()
        } else {
            search(searchText: latestSearchedText, currentPage: currentPage)
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
        
        if let id = gameVM.id,
           myClicked.contains(id) {
            cell.backgroundColor = UIColor(red: 0.879, green: 0.879, blue: 0.879, alpha: 1)
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
        
        
    }
    
    // MARK: - SearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count <= 3 { return }
        search(searchText: searchText, currentPage: 1)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        latestSearchedText = ""
        currentPage = 1
        searchBar.resignFirstResponder()
        searchBar.text = ""
        setUp()
    }
    
    func search(searchText: String, currentPage: Int) {
        if latestSearchedText == searchText { return }
        
        latestSearchedText = searchText
        
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKey)&page_size=\(pageSize)&page=\(currentPage)&search=\(searchText)") else { return }
        APIService().getSearchData(url: url) { [weak self] games in
            guard let self = self else { return }
            if let games = games {
                self.gameListVM = GameListViewModel(games: games)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
