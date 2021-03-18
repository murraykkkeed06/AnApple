//
//  Monster.swift
//  AntAndApple
//
//  Created by 劉孟學 on 2021/3/12.
//

import Foundation
import SpriteKit

enum MonsterType {
    case furry
    case spider
    case fly
}

class Monster: SKSpriteNode {
    
    
    var monsterPositionX: Int!
    var monsterPositionY: Int!
    
    var mosterType: MonsterType!

    var isAlived: Bool = false
    
    var ability: Abiltiy!

//    var bornSecond: TimeInterval!
//    var bornGround: GroundType!
//    var bornChance: CGFloat!
    
    init(texture: SKTexture) {
        super.init(texture: texture, color: .clear, size: CGSize(width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


