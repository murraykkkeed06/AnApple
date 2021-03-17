//
//  Ability.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class Abiltiy{
    
    var attackNumber: CGFloat!
    var defenseNumber: CGFloat!
    var healthNumber: CGFloat!
    
    init(attackNumber: CGFloat, defenseNumber: CGFloat, healthNumber: CGFloat) {
        self.attackNumber = attackNumber
        self.defenseNumber = defenseNumber
        self.healthNumber = healthNumber
    }
}
