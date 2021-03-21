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
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
