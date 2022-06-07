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
    
    var myFavorites = UserDefaults.standard.array(forKey: "favouriteGames")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setUpTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favourites (\(myFavorites.count))"
       
        print(myFavorites)
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        if myFavorites.isEmpty {
            emptyLabel.text = "There is no favourites found."
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as! FavouriteTableViewCell
        
        print("My Favourite Id: \(myFavorites[indexPath.row])")
        
        
        cell.favLabel.text = "my array \(myFavorites[indexPath.row])"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDelete()
            
            myFavorites.remove(at: indexPath.row)
            UserDefaults.standard.set(myFavorites, forKey: "favouriteGames")
            title = "Favourites (\(myFavorites.count))"
            tableView.deleteRows(at: [indexPath], with: .fade)
            
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
