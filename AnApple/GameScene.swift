//
//  GameScene.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: Player!
    var equipmentBag: EquipmentBag!
    var timer: Timer?
    
    
    override func didMove(to view: SKView) {
        player = Player(scene: self)
        equipmentBag = (self.childNode(withName: "equipmentBag") as! EquipmentBag)
        addChild(player)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //set player position when touch
        player.playerHandler(position: location)
    }
    
    
    
    
}



