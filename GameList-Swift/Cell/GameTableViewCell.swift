//
//  GameTableViewCell.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import Foundation
import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ganresLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var metacriticLabel: UILabel!
    
    override func prepareForReuse() {
          backgroundColor = .clear
          backgroundImageView.image = nil
      }
}
 
