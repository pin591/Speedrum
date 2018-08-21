//
//  DetailViewController.swift
//  Speedrum
//
//  Created by Ana Rebollo Pin on 17/8/18.
//  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var game: Game?
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameLogo: UIImageView!
    @IBOutlet weak var gameWinner: UILabel!
    @IBOutlet weak var gameBestRunTime: UILabel!
    var video: String = " "
    
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    typealias JSONDictionaryHandler = (([String:AnyObject]?) -> Void)

    
    @IBAction func showVideo(_ sender: Any) {
        //open(scheme: "https://www.youtube.com/watch?v=4w2_obc2Dqk")
        open(scheme: self.video)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameName.text = game?.name
        let urlImage = URL(string: (game?.logo)!)!
        gameLogo.kf.setImage(with: urlImage)
        downloadJSONFromURL(_completion: { (data) in})
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(scheme): \(success)")
            })
        }
    }
    
    func createGameSessionDataTask(url: URL) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        return URLSession.shared.dataTask(with: request) { data , response , error in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            do {
                                let gamesResponse = try JSONDecoder().decode(PlayersAPI.self, from:data)
                                if let playerUri = gamesResponse.data[0].runs![0].run!.players![0].uri {
                                    DispatchQueue.main.async { [unowned self] in
                                        self.gameBestRunTime.text = String (format:"%f", (gamesResponse.data[0].runs![0].run!.times?.primaryt)!)
                                        self.video = (gamesResponse.data[0].runs![0].run?.videos?.links[0].uri)!
                                    }
                                    let playerUrl = URL(string: playerUri)!
                                    let playerDataTask = self.createPlayerSessionDataTask(url: playerUrl)
                                   
                                    playerDataTask.resume()
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
    }
    
    func createPlayerSessionDataTask(url: URL) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        return URLSession.shared.dataTask(with: request){ data , response , error in
                if error == nil {
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            if let data = data {
                                do {
                                    let runsResponse = try JSONDecoder().decode(PlayerDetails.self, from:data)
                                    DispatchQueue.main.async { [unowned self] in
                                        self.gameWinner.text = (runsResponse.data?.names?.international)!
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
    }
    
    func downloadJSONFromURL(_completion: @escaping JSONDictionaryHandler)
    {
        
        let url = URL(string: "https://www.speedrun.com/api/v1/games/\(game!.id)/records?top=1")!
        let gameSessionDataTask = createGameSessionDataTask(url: url)
        
        gameSessionDataTask.resume();
    }
}
