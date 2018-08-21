//
//  dtos.swift
//  Speedrum
//
//  Created by Ana Rebollo Pin on 15/8/18.
//  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
//

import Foundation

struct GameAPI: Decodable {
    let id: String
    let names: GameAPIName
    let assets: Assets?
}

struct GameAPIName: Decodable {
    let international: String
    let japanese: String?
    let twitch: String
}

struct APIResult: Decodable {
    let data: [GameAPI]
}

struct APILogo: Decodable {
    let uri: URL
    let width: Int
    let height: Int
}

struct Assets : Decodable {
    let logo : APILogo?
    let covertiny: APILogo?
    let coversmall : APILogo?
    let covermedium : APILogo?
    let coverlarge : APILogo?
    let icon : APILogo?
    let trophy1st : APILogo?
    let trophy2nd : APILogo?
    let trophy3rd : APILogo?
    let trophy4th : APILogo?
    let background : APILogo?
    let foreground : APILogo?
    
    enum CodingKeys: String, CodingKey {
        
        case logo = "logo"
        case covertiny = "cover-tiny"
        case coversmall = "cover-small"
        case covermedium = "cover-medium"
        case coverlarge = "cover-large"
        case icon = "icon"
        case trophy1st = "trophy-1st"
        case trophy2nd = "trophy-2nd"
        case trophy3rd = "trophy-3rd"
        case trophy4th = "trophy-4th"
        case background = "background"
        case foreground = "foreground"
    }
}
    
struct PlayersAPI : Decodable {
    let data : [Data]
}

struct Data : Decodable {
    let weblink : String?
    let game : String?
    let category : String?
    let level : String?
    let platform : String?
    let region : String?
    let emulators : String?
    let videoonly : Bool?
    let timing : String?
    let runs : [Runs]?
    
    enum CodingKeys: String, CodingKey {
        
        case weblink = "weblink"
        case game = "game"
        case category = "category"
        case level = "level"
        case platform = "platform"
        case region = "region"
        case emulators = "emulators"
        case videoonly = "video-only"
        case timing = "timing"
        case runs = "runs"
    }
}


struct Runs : Decodable {
    let place : Int?
    let run : Run?
}

struct Run : Decodable {
    let id : String?
    let weblink : String?
    let game : String?
    let level : String?
    let category : String?
    let videos: URLVideo?
    let comment : String?
    let players : [Players]?
    let times : PlayerTimes?
    let date : String?
    let submitted : String?
}

struct URLVideo: Decodable {
    let links: [Links]
}

struct Links:Decodable {
    let uri: String?
}
struct Players : Decodable {
    let rel : String?
    let id : String?
    let uri : String?
}

struct PlayerTimes: Decodable {
    let primary: String
    let primaryt: Double
    
    enum CodingKeys: String, CodingKey {
        
        case primary = "primary"
        case primaryt = "primary_t"
    }
}

struct PlayerDetails: Decodable {
    let data : DataPlayer?
}

struct DataPlayer : Decodable {
    let id : String?
    let names : Names?
}

struct Names : Decodable {
    let international : String?
    let japanese : String?
}





