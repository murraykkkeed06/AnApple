//
//  Ladder.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/19.
//

import Foundation
import SpriteKit


class Ladder: SKSpriteNode {
    
    init(){
        let texture = SKTexture(imageNamed: "ladder")
        super.init(texture: texture, color: .clear, size: CGSize(width: 60, height: 90))
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.zPosition = 2
        self.name = "ladder"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
