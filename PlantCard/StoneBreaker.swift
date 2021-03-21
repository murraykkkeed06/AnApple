//
//  WoodBreaker.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class StoneBreaker: PlantCard {
    
    init(){
        let texture = SKTexture(imageNamed: "stoneBreaker")
        super.init(texture: texture)
        self.name = "stoneBreaker"
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
