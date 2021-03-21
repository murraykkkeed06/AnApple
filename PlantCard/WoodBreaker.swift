//
//  WoodBreaker.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class WoodBreaker: PlantCard {
    
    init(){
        let texture = SKTexture(imageNamed: "woodBreaker")
        super.init(texture: texture)
        self.name = "woodBreaker"
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
