//
//  APIService.swift
//  GameList-Swift
//
//  Created by Burak YAZICI on 01/06/2022.
//

import Foundation
import UIKit

class APIService {
    
    func getData(url: URL, completion: @escaping ([Game]?) -> () ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let gameList = try? JSONDecoder().decode(GameList.self, from: data)
                
                if let gameList = gameList {
                    completion(gameList.results)
                    //print(gameList.results)
                }
            }
        }.resume()
    }
    
    func getDetailData(url: URL, completion: @escaping (GameDetail?) -> () ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let gameList = try? JSONDecoder().decode(GameDetail.self, from: data)
                
                if let gameList = gameList {
                    completion(gameList)
                    //print(gameList.name)
                }
            }
        }.resume()
    }
 
}





