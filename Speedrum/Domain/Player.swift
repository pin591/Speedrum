//
//  Player.swift
//  Speedrum
//
//  Created by Ana Rebollo Pin on 18/8/18.
//  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
//

import Foundation


class Player {
    
    let id: String?
    let time: Double
    let video: String
    
    init(id:String, time: Double, video: String) {
        self.id = id
        self.time = time
        self.video = video
    }
}
