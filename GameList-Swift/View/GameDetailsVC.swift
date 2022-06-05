//
//  GameDetailsVC.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 04/06/2022.
//

import UIKit
import Kingfisher

class GameDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var myArray = UserDefaults.standard.array(forKey: "favouriteGames") as! [Int]
    private var gameDetailsVM: GameDetailViewModel!
   
    var receivedData = 10
    
//    var imageUrl = URL(string: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg")
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setUp()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(favouriteTapped))
        if myArray.contains(receivedData) {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
 
    }

    
    @objc func favouriteTapped() {
       
       
            let userDefaults = UserDefaults.standard
            var strings: [Int] = userDefaults.object(forKey: "favouriteGames") as? [Int] ?? []
            strings.append(receivedData)
            userDefaults.set(strings, forKey: "favouriteGames")
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            print(strings)
        
        
       
    }
    
    func setUp() {
        let url = URL(string: "https://api.rawg.io/api/games/\(receivedData)?key=3be8af6ebf124ffe81d90f514e59856c")!
        APIService().getDetailData(url: url) { gameDetails in
            if let gameDetails = gameDetails {
                self.gameDetailsVM = GameDetailViewModel(gameDetails: gameDetails)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func openReddit() {
        let imageUrl = URL(string: gameDetailsVM!.redditUrl!)!
        UIApplication.shared.open(imageUrl)
    }
    @objc func openWebsite() {
        let imageUrl = URL(string: gameDetailsVM!.website!)!
        UIApplication.shared.open(imageUrl)
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
            
            
            if gameDetailsVM != nil{
                var imageUrl = URL(string: gameDetailsVM!.backgroundImage!)
                cell.nameLabel.text = gameDetailsVM!.name!
                cell.backgroundImageView.kf.setImage(with: imageUrl)
            } else {
                print("bos")
            }
           
            return cell
            
        }else if indexPath.row == 1 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! DescriptionTableViewCell
            if gameDetailsVM != nil{
                cell.descriptionLabel.text = gameDetailsVM!.description!
            } else {
                print("bos")
            }
            
             return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "redditCell") as! RedditTableViewCell
            cell.redditLabel.text = "Visit reddit"
            if gameDetailsVM != nil{
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(openReddit))
                cell.redditLabel.isUserInteractionEnabled = true
                cell.redditLabel.addGestureRecognizer(tap)
                        
            } else {
                print("bos")
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
        return 4
    }



}
