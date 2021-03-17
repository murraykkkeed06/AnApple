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
    var showButton: MSButtonNode!
    var timer: Timer?
    
    
    override func didMove(to view: SKView) {
        player = Player(scene: self)
        //equipmentBag = (self.childNode(withName: "equipmentBag") as! EquipmentBag)
        addChild(player)
        //storagebag is included in a button
        //storageBag = (self.childNode(withName: "//storageBag") as! StorageBag)
        showButton = (self.childNode(withName: "showButton") as! MSButtonNode)
        setupShowButton()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //set player position when touch
        player.playerHandler(position: location)
    }
    
    
    func setupShowButton() {
        showButton.selectedHandler = {
            switch self.showButton.buttonState {
            case .show:
                let action = SKAction.moveTo(x: 652, duration: 1)
                action.timingMode = .easeInEaseOut
                self.showButton.run(action)
                self.showButton.buttonState = .hide
            case .hide:
                let action = SKAction.moveTo(x: 495, duration: 1)
                action.timingMode = .easeInEaseOut
                self.showButton.run(action)
                self.showButton.buttonState = .show
                
            }
        }
    }
    
    
    
    
}



