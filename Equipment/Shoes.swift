//
//  Shoes.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class Shoes: Equipment {
    
    
    init(version: String, equipmentBag: EquipmentBag, showButton: MSButtonNode){
        
        var texture: SKTexture!
        var ability: Abiltiy!
        switch version {
        case "1":
            texture = SKTexture(imageNamed: "shoes_1")
            ability = Abiltiy(attackNumber: 4, defenseNumber: 1, healthNumber: 13)
            //self.name = "shoes_1"
        case "2":
            texture = SKTexture(imageNamed: "shoes_2")
            ability = Abiltiy(attackNumber: 9, defenseNumber: 2, healthNumber: 19)
            //self.name = "shoes_2"
        default:
            break
        }
        
        super.init(texture: texture, type: .shoes, ability: ability, equipmentBag: equipmentBag, showButton: showButton)
        self.name = "shoes"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



