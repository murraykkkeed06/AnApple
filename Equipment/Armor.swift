//
//  Shoes.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class Armor: Equipment {
    
    
    init(version: String, equipmentBag: EquipmentBag, showButton: MSButtonNode){
        
        var texture: SKTexture!
        var ability: Abiltiy!
        switch version {
        case "1":
            texture = SKTexture(imageNamed: "armor_1")
            ability = Abiltiy(attackNumber: 9, defenseNumber: 10, healthNumber: 23)
            //self.name = "shoes_1"
        case "2":
            texture = SKTexture(imageNamed: "armor_2")
            ability = Abiltiy(attackNumber: 7, defenseNumber: 18, healthNumber: 12)
            //self.name = "shoes_2"
        default:
            break
        }
        
        super.init(texture: texture, type: .armor, ability: ability, equipmentBag: equipmentBag, showButton: showButton)
        self.name = "armor"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



