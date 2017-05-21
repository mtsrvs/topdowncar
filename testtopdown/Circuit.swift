//
//  Circuit.swift
//  topdowngame
//
//  Created by Matias Rivas on 07/05/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Circuit: SKSpriteNode {
    var rectangle:SKShapeNode?
    var leftBorder: SKSpriteNode?
    var rightBorder: SKSpriteNode?
    var topBorder: SKSpriteNode?
    var downBorder: SKSpriteNode?
    
    init(sizeValue: CGSize, skc: SKScene) {
        
        //CENTRE
        let bigBodyRectangle = UIBezierPath(rect: CGRect(x: (-sizeValue.width/4), y: (-sizeValue.height/2),
                                                         width: sizeValue.width * 0.5, height: sizeValue.height))
        
        super.init(texture: nil, color: UIColor.brown,
                   size: CGSize(width: sizeValue.width * 0.5, height: sizeValue.height))
        self.position = CGPoint(x: (sizeValue.width), y: (sizeValue.height))
        self.physicsBody = SKPhysicsBody(polygonFrom: bigBodyRectangle.cgPath)
        self.physicsBody?.isDynamic = false

        //LEFT
        let bigBodyRectangleLeft = UIBezierPath(rect: CGRect(x: -sizeValue.width*0.2/2, y: -sizeValue.height,
                                                         width: sizeValue.width*0.2, height: sizeValue.height*2))
        
        leftBorder = SKSpriteNode(texture: nil, color: UIColor.brown,
                                  size: CGSize(width: sizeValue.width*0.2, height: sizeValue.height*2))
        leftBorder?.position = CGPoint(x: sizeValue.width*0.2/2, y: sizeValue.height)
        leftBorder?.physicsBody = SKPhysicsBody(polygonFrom: bigBodyRectangleLeft.cgPath)
        leftBorder?.physicsBody?.isDynamic = false

        //RIGHT
        let bigBodyRectangleRight = UIBezierPath(rect: CGRect(x: -sizeValue.width*0.2/2, y: -sizeValue.height,
                                                             width: sizeValue.width*0.2, height: sizeValue.height*2))
        
        rightBorder = SKSpriteNode(texture: nil, color: UIColor.brown,
                                  size: CGSize(width: sizeValue.width*0.2, height: sizeValue.height*2))
        rightBorder?.position = CGPoint(x: sizeValue.width*1.9, y: sizeValue.height)
        rightBorder?.physicsBody = SKPhysicsBody(polygonFrom: bigBodyRectangleRight.cgPath)
        rightBorder?.physicsBody?.isDynamic = false

        //TOP
        let bigBodyRectangleTop = UIBezierPath(rect: CGRect(x: -sizeValue.width*0.8, y: -sizeValue.width*0.1,
                                                              width: sizeValue.width*1.6, height: sizeValue.width*0.2))
        
        topBorder = SKSpriteNode(texture: nil, color: UIColor.brown,
                                   size: CGSize(width: sizeValue.width*1.6, height: sizeValue.width*0.2))
        topBorder?.position = CGPoint(x: sizeValue.width, y: sizeValue.height*2 - sizeValue.width*0.1)
        topBorder?.physicsBody = SKPhysicsBody(polygonFrom: bigBodyRectangleTop.cgPath)
        topBorder?.physicsBody?.isDynamic = false

        //DOWN
        let bigBodyRectangleDown = UIBezierPath(rect: CGRect(x: -sizeValue.width*0.8, y: -sizeValue.width*0.1,
                                                            width: sizeValue.width*1.6, height: sizeValue.width*0.2))
        
        downBorder = SKSpriteNode(texture: nil, color: UIColor.brown,
                                 size: CGSize(width: sizeValue.width*1.6, height: sizeValue.width*0.2))
        downBorder?.position = CGPoint(x: sizeValue.width, y: sizeValue.width*0.1)
        downBorder?.physicsBody = SKPhysicsBody(polygonFrom: bigBodyRectangleDown.cgPath)
        downBorder?.physicsBody?.isDynamic = false
        
        skc.addChild(self)
        skc.addChild(leftBorder!)
        skc.addChild(rightBorder!)
        skc.addChild(topBorder!)
        skc.addChild(downBorder!)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.CenterWall
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        self.physicsBody?.collisionBitMask = PhysicsCategory.Car

        leftBorder!.physicsBody?.categoryBitMask = PhysicsCategory.LeftWall
        leftBorder!.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        leftBorder!.physicsBody?.collisionBitMask = PhysicsCategory.Car
        
        rightBorder!.physicsBody?.categoryBitMask = PhysicsCategory.RightWall
        rightBorder!.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        rightBorder!.physicsBody?.collisionBitMask = PhysicsCategory.Car
        
        downBorder!.physicsBody?.categoryBitMask = PhysicsCategory.DownWall
        downBorder!.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        downBorder!.physicsBody?.collisionBitMask = PhysicsCategory.Car
        
        topBorder!.physicsBody?.categoryBitMask = PhysicsCategory.TopWall
        topBorder!.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        topBorder!.physicsBody?.collisionBitMask = PhysicsCategory.Car
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
