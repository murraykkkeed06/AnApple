//
//  Furry.swift
//  AntAndApple
//
//  Created by 劉孟學 on 2021/3/12.
//

import Foundation
import SpriteKit

class Furry: Monster {
    
    static var bornSecond: TimeInterval = 10
    static var bornGround: GroundType = .dirt
    static var bornChance: CGFloat = 0.03
    
    init(){
        
        let texture = SKTexture(imageNamed: "furry")
        super.init(texture: texture)
        
        self.mosterType = .furry
        self.zPosition = 1
        self.name = "furry"
        self.ability = Abiltiy(attackNumber: 6, defenseNumber: 5, healthNumber: 50)
        
//        self.physicsBody = SKPhysicsBody()
//        self.physicsBody?.collisionBitMask = 0
//        self.physicsBody?.categoryBitMask = 2
//        //physicsBody?.usesPreciseCollisionDetection = true
//        self.physicsBody?.affectedByGravity = false
//        self.physicsBody?.isDynamic = false
        
        //physicsBody.collisionBitMask = 0xFFFFFFFF

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
