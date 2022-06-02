//
//  GameDetailVC.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import UIKit
import Kingfisher

class GameDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    

    @IBOutlet weak var gameDetailImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    
    @IBOutlet weak var gameDetailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(favoriteTapped))
        
        let imageUrl = URL(string: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg")
        
        gameDetailImageView.kf.setImage(with: imageUrl)
        
    }
    
    @objc func favoriteTapped() {
        print("Button tapped!")
        
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath) as! GameDetailTableViewCell
        
        return cell
    }
   

}
