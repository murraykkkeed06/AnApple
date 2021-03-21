//
//  WoodBreaker.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class ToolBoxCard: PlantCard {
    
    init(){
        let texture = SKTexture(imageNamed: "toolBoxCard")
        super.init(texture: texture)
        self.name = "toolBoxCard"
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
