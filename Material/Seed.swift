//
//  Seed.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class Seed: Material {
    
    init(){
        let texture = SKTexture(imageNamed: "seed")
        super.init(texture: texture)
        self.name = "seed"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = 64
        self.physicsBody?.collisionBitMask = 16
        self.physicsBody?.contactTestBitMask = 1
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
