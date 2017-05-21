//
//  Start.swift
//  topdowngame
//
//  Created by Matias Rivas on 09/05/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Start: SKSpriteNode {
    let bigBodyRectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 5, height: 5))
    let sizeStart:CGSize = CGSize(width: 250, height: 40)

    
    init(position: CGPoint, skc: SKScene) {
        super.init(texture: nil, color: UIColor.black, size: sizeStart)
        self.position = position
        self.physicsBody?.isDynamic = false
        skc.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
