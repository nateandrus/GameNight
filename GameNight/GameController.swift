//
//  GameController.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/22/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class GameController {
    
    static let shared = GameController()
    
    var mostPopularGames: [TopLevelDictionary.Game] = []
        
    let myClientID = "E6Fps1aHC7"
    let baseURL = "https://www.boardgameatlas.com/api"
    
    func fetchMostPopularGames(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.boardgameatlas.com/api/search?order_by=popularity&ascending=false&pretty=true&limit=25&client_id=E6Fps1aHC7") else { completion(false); return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let data = data else { completion(false); return }
            do {
                let jsonDecoder = JSONDecoder()
                let topLevelDict = try jsonDecoder.decode(TopLevelDictionary.self, from: data)
                self.mostPopularGames = topLevelDict.games
                completion(true)
                return
            } catch {
                print(error.localizedDescription)
                completion(false)
                return
            }
        }.resume()
    }
    
    func fetchGames(searchTerm: String, completion: @escaping ([TopLevelDictionary.Game]?) -> Void) {
        guard var baseurl = URL(string: baseURL) else { completion([]); return }
        baseurl.appendPathComponent("search")
        var components = URLComponents(url: baseurl, resolvingAgainstBaseURL: true)
        
        let searchQuery = URLQueryItem(name: "name", value: searchTerm)
        let limitQuery = URLQueryItem(name: "limit", value: "25")
        let clientQuery = URLQueryItem(name: "client_id", value: myClientID)
        components?.queryItems = [searchQuery, limitQuery, clientQuery]
        
        guard let finalURL = components?.url else { completion([]); return }
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion([])
                return
            }
            if let _ = response {
                //print(response)
            }
            guard let data = data else { completion([]); return }
            do {
                let jsonDecoder = JSONDecoder()
                let topLevelDict = try jsonDecoder.decode(TopLevelDictionary.self, from: data)
                completion(topLevelDict.games)
                return 
            } catch {
                print(error.localizedDescription)
                completion([])
                return
            }
            
        }.resume()
    }
    
    func fetchImageFor(gameImageURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: gameImageURL) else { completion(nil); return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else { completion(nil); return }
            guard let gameImage = UIImage(data: data) else { completion(nil); return }
            completion(gameImage)
            
        }.resume()
    }
    
    func createNewDescription(_ oldDescription: String) -> String {
        let returnString = oldDescription.replacingOccurrences(of: "<i>", with: "").replacingOccurrences(of: "</i>", with: "").replacingOccurrences(of: "<br />", with: "").replacingOccurrences(of: "<em>", with: "").replacingOccurrences(of: "</em>", with: "").replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "<strong>", with: "").replacingOccurrences(of: "</strong>", with: "").replacingOccurrences(of: "<ul>", with: "").replacingOccurrences(of: "<li>", with: "").replacingOccurrences(of: "</li>", with: "").replacingOccurrences(of: "</ul>", with: "")
        return returnString
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
