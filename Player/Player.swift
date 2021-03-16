//
//  Player.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

enum PlayerState {
    case goingLeft
    case goingRight
    case idle
}

class Player: SKSpriteNode {
    //player move distance per 0.01 sec
    let bornPosition: CGPoint = CGPoint(x: 300, y: 80)
    let playerMoveDistance: CGFloat = 1
    var isMoving = false
    private var _playerState: PlayerState!
    var playerState: PlayerState {
        set{
            self.removeAllActions()
            self.position.y = bornPosition.y
            _playerState = newValue
            switch newValue {
            case .goingLeft:
                
                self.run(SKAction(named: "playerGoingLeft")!)
            case .goingRight:
                self.run(SKAction(named: "playerGoingRight")!)
            case .idle:
                self.run(SKAction(named: "playerIdle")!)
            }
        }
        get{
            return _playerState
        }
    }
    
    init() {
        let texture = SKTexture(imageNamed: "nakedAnt_2")
        super.init(texture: texture, color: .clear , size: CGSize(width: 50, height: 50))
        self.playerState = .idle
        self.zPosition = 1
        self.position = bornPosition
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


