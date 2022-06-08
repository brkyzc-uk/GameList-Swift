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
    var favGameGenres = UserDefaults.standard.array(forKey: "favGameGenres") ?? []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpTableView()

    }
    override func viewDidAppear(_ animated: Bool) {
        favGameNames = UserDefaults.standard.array(forKey: "favGameNames") ?? []
        favMetaCritics = UserDefaults.standard.array(forKey: "favMetaCritics") ?? []
        favGameIds = UserDefaults.standard.array(forKey: "favGameIds") ?? []
        favGameImages = UserDefaults.standard.array(forKey: "favGameImages") ?? []
        favGameGenres = UserDefaults.standard.array(forKey: "favGameGenres") ?? []
        navigationController?.navigationBar.prefersLargeTitles = true
        self.setUpTableView()
        self.tableView.reloadData()
    }
    
 
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 160
        
        if favGameIds.isEmpty {
            emptyLabel.text = "There is no favourites found."
            title = "Favourites"
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
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
        cell.ganresLabel.text = "Action, adventure"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
          confirmDelete(for: indexPath)
        }
        
    }
    
    func confirmDelete(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Favourite", message: "Are you sure you want to permanently delete?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
                self.tableView.beginUpdates()
                self.favGameIds.remove(at: indexPath.row)
                self.favGameNames.remove(at: indexPath.row)
                self.favMetaCritics.remove(at: indexPath.row)
                self.favGameImages.remove(at: indexPath.row)
                self.favGameGenres.remove(at: indexPath.row)
                
                UserDefaults.standard.set(self.favGameIds, forKey: "favGameIds")
                UserDefaults.standard.set(self.favGameNames, forKey: "favGameNames")
                UserDefaults.standard.set(self.favMetaCritics, forKey: "favMetaCritics")
                UserDefaults.standard.set(self.favGameImages, forKey: "favGameImages")
                UserDefaults.standard.set(self.favGameGenres, forKey: "favGameGenres")
                
                self.title = "Favourites (\(self.favGameIds.count))"
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()
        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
