//
//  Seed.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class Egg: Material {
    
    init(){
        let texture = SKTexture(imageNamed: "egg")
        super.init(texture: texture)
        self.name = "egg"
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
