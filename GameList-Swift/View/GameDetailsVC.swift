//
//  GameDetailsVC.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 04/06/2022.
//

import UIKit
import Kingfisher

class GameDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var favGameId = UserDefaults.standard.array(forKey: "favGameIds") as? [Int] ?? []
    
    private var gameDetailsVM: GameDetailViewModel!
   
    var receivedData = 10
    var apiKey = "3be8af6ebf124ffe81d90f514e59856c"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setUp()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(favouriteTapped))
        
        if favGameId.contains(receivedData) {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUp() {
        let url = URL(string: "https://api.rawg.io/api/games/\(receivedData)?key=\(apiKey)")!
        APIService().getDetailData(url: url) { [weak self] gameDetails in
            guard let self = self else { return }

            if let gameDetails = gameDetails {
                self.gameDetailsVM = GameDetailViewModel(gameDetails: gameDetails)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func openReddit() {
        if let gameDetailsVM = gameDetailsVM {
            if let redditLink = gameDetailsVM.redditUrl {
                if let redditUrl = URL(string: redditLink) {
                    UIApplication.shared.open(redditUrl)
                }
            }
        }
    }
    
    @objc func openWebsite() {
        if let gameDetailsVM = gameDetailsVM {
            if let websiteLink = gameDetailsVM.website {
                if let websiteUrl = URL(string: websiteLink) {
                    UIApplication.shared.open(websiteUrl)
                }
            }
        }
    }
    
    @objc func favouriteTapped() {
    
        let userDefaults = UserDefaults.standard
        
        var favGameIds: [Int] = userDefaults.object(forKey: "favGameIds") as? [Int] ?? []
        var favMetaCritics: [Int] = userDefaults.object(forKey: "favMetaCritics") as? [Int] ?? []
        var favGameNames: [String] = userDefaults.object(forKey: "favGameNames") as? [String] ?? []
        var favGameImages: [String] = userDefaults.object(forKey: "favGameImages") as? [String] ?? []
        
        if let favGameId = gameDetailsVM.id {
            favGameIds.append(favGameId)
        }
        
        if let favMetaCritic = gameDetailsVM.metaCritic {
            favMetaCritics.append(favMetaCritic)
        }
        
        if let favGameName = gameDetailsVM.name {
            favGameNames.append(favGameName)
        }
        
        if let favGameImage = gameDetailsVM.backgroundImage {
            favGameImages.append(favGameImage)
        }
        
        userDefaults.set(favGameIds, forKey: "favGameIds")
        userDefaults.set(favMetaCritics, forKey: "favMetaCritics")
        userDefaults.set(favGameNames, forKey: "favGameNames")
        userDefaults.set(favGameImages, forKey: "favGameImages")
        
        
        navigationItem.rightBarButtonItem?.title = "Favourited"
        navigationItem.rightBarButtonItem?.isEnabled = false
        //print(strings)

    }
    
    // MARK: - TableView Functions
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
            if gameDetailsVM != nil {

                let imageUrl = URL(string: gameDetailsVM!.backgroundImage!)
                cell.nameLabel.text = gameDetailsVM!.name!
                cell.backgroundImageView.kf.setImage(with: imageUrl)

            } else {
                print("empty row 0")
            }
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! DescriptionTableViewCell
            if gameDetailsVM != nil {
                cell.descriptionLabel.text = gameDetailsVM!.description!
            } else {
                print("empty row 1")
            }
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "redditCell") as! RedditTableViewCell
            cell.redditLabel.text = "Visit reddit"
            if gameDetailsVM != nil{
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(openReddit))
                cell.redditLabel.isUserInteractionEnabled = true
                cell.redditLabel.addGestureRecognizer(tap)
                        
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "websiteCell") as! WebsiteTableViewCell
            cell.websiteLabel.text = "Visit website"
            if gameDetailsVM != nil{
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
                cell.websiteLabel.isUserInteractionEnabled = true
                cell.websiteLabel.addGestureRecognizer(tap)
                        
            } else {
                print("bos")
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.gameDetailsVM == nil {
            return 0
        }
        return 4
    }
    
}
