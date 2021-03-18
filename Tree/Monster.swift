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
}

class Monster: SKSpriteNode {
    var attackNumber: CGFloat!
    var defenseNumber: Int!
    var monsterPositionX: Int!
    var monsterPositionY: Int!
    var mosterType: MonsterType!
//    var bornRateEveryMinute: CGFloat!
    var isAlived: Bool = false
    
    var healthNumber : CGFloat!

    
    
    init(texture: SKTexture, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


