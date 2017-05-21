//
//  Tire.swift
//  topdowngame
//
//  Created by Matias Rivas on 07/05/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Car: SKSpriteNode {
    let bodyRectangle = UIBezierPath(rect: CGRect(x: -40, y: -80, width: 80, height: 160))
    let sizeTire:CGSize = CGSize(width: 80, height: 160)
    let rotationLimit:CGFloat = CGFloat(Double.pi / 8)
    let aRotation:CGFloat = CGFloat(Double.pi / 16)
    var rotationCurrent:CGFloat?
    
    var m_maxLateralImpulse:CGFloat?
    var m_currentTraction:CGFloat?
    var m_maxForwardSpeed:CGFloat?
    var m_maxDriveForce:CGFloat?
    var m_maxBackwardSpeed:CGFloat?
    var m_controlState:UInt32?
    
    let maxForwardSpeed:CGFloat = 250;
    let maxBackwardSpeed:CGFloat = -40;
    let frontTireMaxDriveForce:CGFloat = 500;
    let frontTireMaxLateralImpulse:CGFloat = 7.5;
    
    init(position: CGPoint, pc: UInt32) {
        super.init(texture: SKTexture(imageNamed: "bluecar"), color: UIColor.red, size: sizeTire)
        self.position = position
        self.physicsBody = SKPhysicsBody(polygonFrom: bodyRectangle.cgPath)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.mass = 10

        self.physicsBody?.categoryBitMask = pc
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Checkpoint

        m_maxForwardSpeed = maxForwardSpeed
        m_maxBackwardSpeed = maxBackwardSpeed
        m_maxDriveForce = frontTireMaxDriveForce
        m_maxLateralImpulse = frontTireMaxLateralImpulse
        m_controlState = CarState.TDC_NO_MOVE
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFriction() {
        let impulse:CGVector = getLateralVelocity() * (self.physicsBody?.mass)! * (-1);
        self.physicsBody?.applyImpulse(impulse, at: self.position)
        self.physicsBody?.applyAngularImpulse(-0.1 * (self.physicsBody?.angularDamping)! * (self.physicsBody?.angularVelocity)!)
        let currentForwardNormal:CGVector = getForwardVelocity();
        let currentForwardSpeed:CGFloat = (CGVector(dx: 1.0, dy: 0.0).doRotation(angle: self.zRotation)).length();
        let dragForceMagnitude:CGFloat = -2 * currentForwardSpeed
        self.physicsBody?.applyForce(currentForwardNormal * dragForceMagnitude, at: self.position)
    }
    
    func updateDrive(controlState:UInt32) {
        var desiredSpeed:CGFloat = 0;
        switch ( controlState & (CarState.TDC_UP | CarState.TDC_DOWN) ) {
            case CarState.TDC_UP:
                desiredSpeed = m_maxForwardSpeed!
            case CarState.TDC_DOWN:
                desiredSpeed = m_maxBackwardSpeed!
            default:
                return
        }
    
        let currentForwardNormal:CGVector = CGVector(dx: 0.0, dy: 1.0).doRotation(angle: self.zRotation)
        let currentSpeed:CGFloat = dotProduct(vector1: getForwardVelocity(), vector2: currentForwardNormal)
    
        var force:CGFloat = 0;
        if desiredSpeed > currentSpeed {
            force = m_maxDriveForce!
        } else if desiredSpeed < currentSpeed {
            force = -m_maxDriveForce!
        } else {
            return
        }

        self.physicsBody?.applyForce(currentForwardNormal * force, at: self.position)
    }
    
    func updateTurn(controlState:UInt32) {
        var desiredTorque:CGFloat = 0;
        switch ( controlState & (CarState.TDC_LEFT | CarState.TDC_RIGHT) ) {
            case CarState.TDC_LEFT:
                desiredTorque = 2
            case CarState.TDC_RIGHT:
                desiredTorque = -2
            default:
                break
        }
        self.physicsBody?.applyTorque(desiredTorque)
    }

    func moveLeft() {
        m_controlState = CarState.TDC_LEFT
    }
    
    func moveRight() {
        m_controlState = CarState.TDC_RIGHT
    }

    func moveUp() {
        m_controlState = CarState.TDC_UP
    }
    
    func moveDown() {
        m_controlState = CarState.TDC_DOWN
    }
    
    
    func update() {
        self.updateFriction()
        self.updateDrive(controlState: m_controlState!)
        self.updateTurn(controlState: m_controlState!)
        
        //Con esto evito que el auto se quede girando
        if m_controlState == CarState.TDC_LEFT || m_controlState == CarState.TDC_RIGHT {
            m_controlState = CarState.TDC_NO_MOVE
        }
    }
    
    func dotProduct(vector1: CGVector, vector2: CGVector) -> CGFloat {
        let cosAngle = ((vector1.dx * vector2.dx) + (vector1.dy * vector2.dy)) / (vector1.length() + vector2.length())
        return vector1.length() * vector2.length() * cosAngle
    }
    
    func getLateralVelocity() -> CGVector {
        let normalLateral = CGVector(dx: 1.0, dy: 0.0).doRotation(angle: self.zRotation)
        let dotProd = dotProduct(vector1: normalLateral, vector2: (self.physicsBody?.velocity)!)
        return normalLateral * dotProd
    }
    
    func getForwardVelocity() -> CGVector {
        let normalForward = CGVector(dx: 0.0, dy: 1.0).doRotation(angle: self.zRotation)
        let dotProd = dotProduct(vector1: normalForward, vector2: (self.physicsBody?.velocity)!)
        return normalForward * dotProd
    }
    
    func alterMaxSpeed(factor: CGFloat) {
        m_maxForwardSpeed = maxForwardSpeed/factor
        m_maxBackwardSpeed = maxBackwardSpeed/factor
    }
    
    func defaultMaxSpeed() {
        m_maxForwardSpeed = maxForwardSpeed
        m_maxBackwardSpeed = maxBackwardSpeed
    }
}
