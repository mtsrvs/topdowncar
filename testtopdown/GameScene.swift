//
//  GameScene.swift
//  testtopdown
//
//  Created by Matias Rivas on 17/04/2017.
//  Copyright © 2017 itba. All rights reserved.
//

//SKCameraNode

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var createChecks:Bool = false
    
    var timer:SKLabelNode?
    var timerShadow:SKLabelNode?
    var seconds:Int = 0
    var minutes:Int = 0
    var lapCounter:SKLabelNode?
    var lapCounterShadow:SKLabelNode?
    var counter:Int = 0
    var nextCheckpoint:Int = 0
    let offset:CGFloat = -1
    
    var circuit: Circuit?
    var grass: Grass?
    var start: Start?
    var car:Car?

    var ckp0: Checkpoint?
    var ckp1: Checkpoint?
    var ckp2: Checkpoint?
    var ckp3: Checkpoint?
    var ckp4: Checkpoint?
    
    var positionChkp0:CGPoint?
    var positionChkp1:CGPoint?
    var positionChkp2:CGPoint?
    var positionChkp3:CGPoint?
    var positionChkp4:CGPoint?
    
    let totalLaps:Int = 3
    let cam:SKCameraNode = SKCameraNode()
    let zoomInAction = SKAction.scale(to: -2000, duration: 0.1)

    var buttonDown:SKSpriteNode?
    var buttonUp:SKSpriteNode?
    var buttonLeft:SKSpriteNode?
    var buttonRight:SKSpriteNode?

    override func didMove(to view: SKView) {
        view.showsPhysics = false
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        //defino las posiciones de los checks para luego volver
        //a mostrar cuando inicia otra vuelta
        positionChkp0 = CGPoint(x: size.width * 0.5, y: size.height * 0.8)
        positionChkp1 = CGPoint(x: size.width * 1.5, y: size.height * 0.8)
        positionChkp2 = CGPoint(x: size.width * 0.5, y: size.height * 1.2)
        positionChkp3 = CGPoint(x: size.width, y: size.height * 0.3)
        positionChkp4 = CGPoint(x: size.width, y: size.height * 1.7)

        //start
        start = Start(position: positionChkp0!, skc: self)
        createStartCheckpoint()

        //checkpoints
        createCheckpoints()
        
        //Circuit
        circuit = Circuit(sizeValue: size, skc: self)
        
        //Grass
        grass = Grass(position: CGPoint(x: size.width * 0.6, y: size.height * 1.7),
                  grassSize: CGSize(width: 300, height: 250), skc: self)
        
        //Car        
        car = Car(position: CGPoint(x: size.width * 0.55, y: size.height * 0.5), pc: PhysicsCategory.Car)
        self.addChild(car!)
        
        //Camera
        self.camera = cam
        cam.yScale = 0.7
        cam.xScale = 0.7

        //Timer
        timer = SKLabelNode(fontNamed: "Helvetica-Bold")
        timer?.text = "TIME: 00:00"
        timer?.fontColor = SKColor.black
        timer?.fontSize = 30
        timer?.position = CGPoint(x: cam.position.x, y: cam.position.y - size.height/3)
        
        timerShadow = SKLabelNode(fontNamed: "Helvetica-Bold")
        timerShadow?.text = "TIME: 00:00"
        timerShadow?.fontColor = SKColor.red
        timerShadow?.fontSize = 30
        timerShadow?.zPosition = (timer?.zPosition)! + 1
        timerShadow?.position = CGPoint(x: cam.position.x + offset, y: cam.position.y - size.height/3 + offset)
        
        //Lap
        lapCounter = SKLabelNode(fontNamed: "Helvetica-Bold")
        lapCounter?.text = "LAP \(counter)/\(totalLaps)"
        lapCounter?.fontColor = SKColor.black
        lapCounter?.fontSize = 30
        lapCounter?.position = CGPoint(x: cam.position.x - size.width/4, y: cam.position.y - size.height/3)

        lapCounterShadow = SKLabelNode(fontNamed: "Helvetica-Bold")
        lapCounterShadow?.text = "LAP \(counter)/\(totalLaps)"
        lapCounterShadow?.fontColor = SKColor.red
        lapCounterShadow?.fontSize = 30
        lapCounterShadow?.zPosition = (lapCounter?.zPosition)! + 1
        lapCounterShadow?.position = CGPoint(x: cam.position.x - size.width/4 + offset, y: cam.position.y - size.height/3 + offset)
        
        self.addChild(lapCounter!)
        self.addChild(lapCounterShadow!)
        self.addChild(timerShadow!)
        self.addChild(timer!)
        
        self.timer?.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.run(updateTimer)])))
        
        //Buttons
        let buttonSize:CGSize = CGSize(width: 60, height: 60)
        buttonDown = SKSpriteNode(texture: SKTexture(imageNamed: "down"), color: UIColor.red, size: buttonSize)
        buttonUp = SKSpriteNode(texture:SKTexture(imageNamed: "up"), color: UIColor.red, size: buttonSize)
        buttonLeft = SKSpriteNode(texture:SKTexture(imageNamed: "left"), color: UIColor.red, size: buttonSize)
        buttonRight = SKSpriteNode(texture:SKTexture(imageNamed: "right"), color: UIColor.red, size: buttonSize)
        
        buttonDown?.position = CGPoint(x:cam.position.x, y: cam.position.y - size.height/3.1)
        buttonUp?.position = CGPoint(x:cam.position.x, y: cam.position.y - size.height/4.1)
        buttonLeft?.position = CGPoint(x:cam.position.x - size.width/8, y: cam.position.y - size.height/3.5)
        buttonRight?.position = CGPoint(x:cam.position.x + size.width/8, y: cam.position.y - size.height/3.5)
        
        buttonDown?.name = "down"
        buttonUp?.name = "up"
        buttonLeft?.name = "left"
        buttonRight?.name = "right"
        
        self.addChild(buttonDown!)
        self.addChild(buttonUp!)
        self.addChild(buttonLeft!)
        self.addChild(buttonRight!)
        
        createSceneContents()
      }
    
    func createSceneContents() {
        self.size = CGSize(width: self.size.width * 2, height: self.size.height * 2)
        self.backgroundColor = .white
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func move() {
        car?.update()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }

        if !self.nodes(at: pos).isEmpty {
            let node:SKSpriteNode = self.nodes(at: pos).first as! SKSpriteNode
            if node.name != nil {
                switch node.name! {
                case "down":
                    car?.moveDown()
                case "up":
                    car?.moveUp()
                case "left":
                    car?.moveLeft()
                case "right":
                    car?.moveRight()
                default:
                    break
                }
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        grass?.carInside(car: car!)
        move()
        //Todo se updatea segun la posicion de la camara
        cam.position = (car?.position)!
        lapCounter?.position = CGPoint(x: cam.position.x - size.width/4, y: cam.position.y - size.height/3)
        lapCounterShadow?.position = CGPoint(x: cam.position.x - size.width/4 + offset, y: cam.position.y - size.height/3 + offset)
        timer?.position = CGPoint(x: cam.position.x + size.width/4, y: cam.position.y - size.height/3)
        timerShadow?.position = CGPoint(x: cam.position.x + size.width/4 + offset, y: cam.position.y - size.height/3 + offset)
        
        buttonDown?.position = CGPoint(x:cam.position.x, y: cam.position.y - size.height/3.1)
        buttonUp?.position = CGPoint(x:cam.position.x, y: cam.position.y - size.height/4.1)
        buttonLeft?.position = CGPoint(x:cam.position.x - size.width/8, y: cam.position.y - size.height/3.5)
        buttonRight?.position = CGPoint(x:cam.position.x + size.width/8, y: cam.position.y - size.height/3.5)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        var contactCheckpoint:Checkpoint?
    
        firstBody = contact.bodyA
        secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.Checkpoint {
            contactCheckpoint = firstBody.node as? Checkpoint
            if nextCheckpoint == contactCheckpoint?.order {
                contactCheckpoint?.removeFromParent()
                nextCheckpoint += 1
                if createChecks {
                    createCheckpoints()
                    updateLapCounter()
                    createChecks = false
                }
            }
        }

        if secondBody.categoryBitMask == PhysicsCategory.Checkpoint {
            contactCheckpoint = secondBody.node as? Checkpoint
            if nextCheckpoint == contactCheckpoint?.order {
                contactCheckpoint?.removeFromParent()
                nextCheckpoint += 1
                if createChecks {
                    createCheckpoints()
                    updateLapCounter()
                    createChecks = false
                }
            }
        }
        
        if nextCheckpoint == 5 {
            createStartCheckpoint()
            nextCheckpoint = 0
            createChecks = true
        }
    }
    
    func updateLapCounter() {
        counter += 1
        
        if counter >= totalLaps {
            lapCounter?.text = "WINNER!!!"
            lapCounterShadow?.text = "WINNER!!!"
        } else {
            lapCounter?.text = "LAP \(counter)/\(totalLaps)"
            lapCounterShadow?.text = "LAP \(counter)/\(totalLaps)"
        }
    }
    func updateTimer() {
        var leadingZero = ""
        var leadingZeroMin = ""
        
        seconds += 1
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        if minutes  / 60 <= 9 { leadingZeroMin = "0" } else { leadingZeroMin = "" }
        if seconds <= 9 { leadingZero = "0" } else { leadingZero = "" }
        
        timer?.text = "TIME: \(leadingZeroMin)\(minutes):\(leadingZero)\(seconds)"
        timerShadow?.text = "TIME: \(leadingZeroMin)\(minutes):\(leadingZero)\(seconds)"
    }

    func createStartCheckpoint() {
        ckp0 = Checkpoint(position: positionChkp0!, sizeCkp: CGSize(width: 250, height: 40),
                          skc: self, order: 0, bodyWidth: 200, bodyHeight: 40)
    }
    
    func createCheckpoints() {
        ckp1 = Checkpoint(position: positionChkp1!, sizeCkp: CGSize(width: 250, height: 40),
                          skc: self, order: 3, bodyWidth: 200, bodyHeight: 40)
        
        ckp2 = Checkpoint(position: positionChkp2!, sizeCkp: CGSize(width: 250, height: 40),
                          skc: self, order: 1, bodyWidth: 200, bodyHeight: 40)
        
        ckp3 = Checkpoint(position: positionChkp3!, sizeCkp: CGSize(width: 40, height: 300),
                          skc: self, order: 4, bodyWidth: 40, bodyHeight: 200)
        
        ckp4 = Checkpoint(position: positionChkp4!, sizeCkp: CGSize(width: 40, height: 300),
                          skc: self, order: 2, bodyWidth: 40, bodyHeight: 200)
    }
}
