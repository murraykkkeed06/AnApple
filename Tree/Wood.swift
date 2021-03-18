//
//  Dirt.swift
//  AntAndApple
//
//  Created by 劉孟學 on 2021/3/10.
//

import Foundation
import SpriteKit

class Wood: GroundNode {
    
    init(){
        
        let texture = SKTexture(imageNamed: "wood")
        super.init(texture: texture, color: .clear, size: CGSize(width: 60, height: 45))
        self.zPosition = 1
        //self.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.alpha = 1
        self.isDigged = false
        self.neighborIsDigged = false
        self.name = "wood"
        
//        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 45))
//        self.physicsBody?.affectedByGravity = false
//        self.physicsBody?.isDynamic = false
//        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemnet!")
    }
}
