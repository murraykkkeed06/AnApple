//
//  Apple.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class Apple: Material {
    
    init(){
        let texture = SKTexture(imageNamed: "apple")
        super.init(texture: texture)
        self.name = "apple"
        self.ability = Abiltiy(attackNumber: 0, defenseNumber: 0, healthNumber: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
