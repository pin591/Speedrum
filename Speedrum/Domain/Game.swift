//
//  Game.swift
//  Speedrum
//
//  Created by Ana Rebollo Pin on 15/8/18.
//  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
//

import Foundation

class Game {
    
    var id: String
    var name: String
    var logo: String
   
    init(id: String, name:String, logo: String) {
        self.id = id
        self.name = name
        self.logo = logo
    }
}
