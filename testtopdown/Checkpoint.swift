//
//  Checkpoint.swift
//  topdowngame
//
//  Created by Matias Rivas on 11/05/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Checkpoint: SKSpriteNode {
    var order:Int?
    
    init(position: CGPoint, sizeCkp: CGSize, skc: SKScene, order:Int, bodyWidth:Int, bodyHeight:Int) {
        super.init(texture: nil, color: UIColor.black.withAlphaComponent(0), size: sizeCkp)
        let body = UIBezierPath(rect: CGRect(x: -bodyWidth/2, y: -bodyHeight/2, width: bodyWidth , height: bodyHeight))
      
        self.physicsBody = SKPhysicsBody(polygonFrom: body.cgPath)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Checkpoint
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        self.zPosition = -1000
        self.position = position
        self.order = order
        skc.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
