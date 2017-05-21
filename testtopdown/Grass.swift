//
//  Grass.swift
//  topdowngame
//
//  Created by Matias Rivas on 21/05/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Grass: SKSpriteNode {
    init(position: CGPoint, grassSize: CGSize, skc: SKScene) {
        super.init(texture: nil, color: UIColor.green.withAlphaComponent(0.6), size: grassSize)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Grass
        self.position = position
        self.zPosition = -100
        self.name = "grass"

        skc.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func carInside(car: Car) {
        if(self.intersects(car)) {
            car.alterMaxSpeed(factor: 5.0)
        } else {
            car.defaultMaxSpeed()
        }
    }
}
