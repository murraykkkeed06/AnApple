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
    
    var gridXY: GridXY!
    var dieDrop: () -> Void = {print("not implemented!")}
    var hasDrop = false
    var mosterType: MonsterType!
    private var _isAlived: Bool!
    var isAlived: Bool {
        set{
            _isAlived = newValue
            switch newValue {
            case true:
                break
            case false:
                if !hasDrop{
                self.dieDrop()
                }
            }
        }
        get{
            return _isAlived
        }
    }
    
    var ability: Abiltiy!
    
    var attackInterval: TimeInterval!
    
    
    
//    //var isGoingLeft = false
//    private var _isGoingRight: Bool!
//
//    var isGoingRight: Bool {
//        set{
//            _isGoingRight = newValue
//
//            switch newValue {
//            case true:
//                self.run(SKAction(named: "monsterGoingRight")!)
//                print("right")
//
//            case false:
//                print("left!")
//                self.run(SKAction(named: "monsterGoingLeft")!)
//
//
//            }
//        }
//        get{
//            return _isGoingRight
//        }
//    }
    
    var isDiggedOut = false

//    var bornSecond: TimeInterval!
//    var bornGround: GroundType!
//    var bornChance: CGFloat!
    
    init(texture: SKTexture) {
        super.init(texture: texture, color: .clear, size: CGSize(width: 40, height: 40))
        self.isAlived = true
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = 32
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
        
        //self.isGoingRight = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveAround(groundList: [[GroundNode]]) {
            
    }
}


