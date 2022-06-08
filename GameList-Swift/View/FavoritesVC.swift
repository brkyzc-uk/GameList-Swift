//
//  FavoritesVC.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import UIKit

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var favGameNames = UserDefaults.standard.array(forKey: "favGameNames") ?? []
    var favMetaCritics = UserDefaults.standard.array(forKey: "favMetaCritics") ?? []
    var favGameIds = UserDefaults.standard.array(forKey: "favGameIds") ?? []
    var favGameImages = UserDefaults.standard.array(forKey: "favGameImages") ?? []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favGameNames = UserDefaults.standard.array(forKey: "favGameNames") ?? []
        favMetaCritics = UserDefaults.standard.array(forKey: "favMetaCritics") ?? []
        favGameIds = UserDefaults.standard.array(forKey: "favGameIds") ?? []
        favGameImages = UserDefaults.standard.array(forKey: "favGameImages") ?? []
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setUpTableView()
        //print(myFavorites)
        
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 160
        
        if favGameIds.isEmpty {
            emptyLabel.text = "There is no favourites found."
            title = "Favourites"
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            title = "Favourites (\(favGameIds.count))"
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favGameNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
        let indexRow = indexPath.row
        let imageUrl = URL(string: favGameImages[indexRow] as! String)
        let metaCritic = favMetaCritics[indexRow] as! Int
        
        cell.nameLabel.text = favGameNames[indexRow] as? String
        cell.backgroundImageView.kf.setImage(with: imageUrl)
        cell.metacriticLabel.text = String(metaCritic) 
        
        
        
        
//        if favMetaCritics.isEmpty { cell.metacriticLabel.text = "" }
//        else {
//            cell.metacriticLabel.text = "\(favMetaCritics[indexRow])"
//        }
        
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDelete()
            tableView.beginUpdates()
            favGameIds.remove(at: indexPath.row)
            favGameNames.remove(at: indexPath.row)
            favMetaCritics.remove(at: indexPath.row)
            favGameImages.remove(at: indexPath.row)
            
            UserDefaults.standard.set(favGameIds, forKey: "favGameIds")
            UserDefaults.standard.set(favGameNames, forKey: "favGameNames")
            UserDefaults.standard.set(favMetaCritics, forKey: "favMetaCritics")
            UserDefaults.standard.set(favGameImages, forKey: "favGameImages")
            
            title = "Favourites (\(favGameIds.count))"
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
        
    }
    
    func confirmDelete() {
        let alert = UIAlertController(title: "Delete Favourite", message: "Are you sure you want to permanently delete?", preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
