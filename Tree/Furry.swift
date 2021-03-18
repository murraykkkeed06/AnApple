//
//  Furry.swift
//  AntAndApple
//
//  Created by 劉孟學 on 2021/3/12.
//

import Foundation
import SpriteKit

class Furry: Monster {
    init(){
        
        
        let texture = SKTexture(imageNamed: "furry")
        super.init(texture: texture, color: .clear, size: CGSize(width: 50, height: 50))
    
        self.zPosition = 2
        
        //self.anchorPoint = CGPoint(x: 0, y: 0)
        self.alpha = 1
        self.name = "furry"
        
//        self.physicsBody = SKPhysicsBody()
//        self.physicsBody?.collisionBitMask = 0
//        self.physicsBody?.categoryBitMask = 2
//        //physicsBody?.usesPreciseCollisionDetection = true
//        self.physicsBody?.affectedByGravity = false
//        self.physicsBody?.isDynamic = false
        
        //physicsBody.collisionBitMask = 0xFFFFFFFF
//        self.healthNumber = 50
//        self.attackPoint = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
