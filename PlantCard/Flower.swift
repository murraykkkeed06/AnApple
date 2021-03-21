//
//  Flower.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class Flower: PlantCard {
    
    
    init(){
        let texture = SKTexture(imageNamed: "flower")
        super.init(texture: texture)
        self.name = "flowerCard"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
