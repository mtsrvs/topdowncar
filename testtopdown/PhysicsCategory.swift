//
//  PhysicsCategory.swift
//  topdowngame
//
//  Created by Matias Rivas on 08/05/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:UInt32 = 0
    static let Start:UInt32 = UInt32.max
    
    static let LeftWall:UInt32 = 0b10
    static let RightWall:UInt32 = 0b11
    static let DownWall:UInt32 = 0b100
    static let TopWall:UInt32 = 0b101
    static let CenterWall:UInt32 = 0b110
    
    static let Car:UInt32 = 0b111

    static let Checkpoint:UInt32 = 0b1011
    static let CheckpointStart:UInt32 = 0b1100
    
    static let Grass:UInt32 = 0b10000
}
