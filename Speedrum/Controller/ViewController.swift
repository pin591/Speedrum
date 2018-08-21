//
//  ViewController.swift
//  Speedrum
//
//  Created by Ana Rebollo Pin on 15/8/18.
//  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var games = [Game]()
    var url = URL(string: "https://www.speedrun.com/api/v1/games")!
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    typealias JSONDictionaryHandler = (([String:AnyObject]?) -> Void)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJSONFromURL(_completion: { (data) in })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = games[indexPath.row].name
        let url = URL(string: games[indexPath.row].logo)!
        cell.imageView?.kf.setImage(with: url)
        return cell
    }
    
    func mapDTOInModel(game: GameAPI) {
        let currentGame = Game(id: game.id, name: game.names.international,logo: (game.assets?.coversmall?.uri.absoluteString)!)
        self.games.append(currentGame)
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        detailVC.game = games[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func downloadJSONFromURL(_completion: @escaping JSONDictionaryHandler)
    {
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request)
        {(data, response,error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            do {
                                let gamesResponse = try JSONDecoder().decode(APIResult.self, from:data)
                                for game in gamesResponse.data {
                                    self.mapDTOInModel(game:game)
                                }
                            } catch let error as NSError {
                                print ("Error processing json data: \(error.description)")
                            }
                        }
                    default:
                        print("HTTP Response Code: \(httpResponse.statusCode)")
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    


}

