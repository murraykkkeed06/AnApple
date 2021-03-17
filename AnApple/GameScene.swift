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
    var healthBarBackground: SKSpriteNode!
    var timer: Timer?
    
    
    override func didMove(to view: SKView) {
        player = Player(scene: self)
        //equipmentBag = (self.childNode(withName: "equipmentBag") as! EquipmentBag)
        addChild(player)
        //storagebag is included in a button
        //storageBag = (self.childNode(withName: "//storageBag") as! StorageBag)
        showButton = (self.childNode(withName: "showButton") as! MSButtonNode)
        setupShowButton()
        
        healthBarBackground = (self.childNode(withName: "healthBarBackground") as! SKSpriteNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //set player position when touch
        player.playerHandler(position: location)
        
        let nodeAtPoint = nodes(at: location)
        print("\(nodeAtPoint.n)")
    }
    
    override func update(_ currentTime: TimeInterval) {
        countPlayerAbility(healthBarBackground: healthBarBackground, player: player)
    }
    
    
    
    
    
    
    
    func countPlayerAbility(healthBarBackground: SKSpriteNode, player: Player) {
        let attackNumber = (healthBarBackground.childNode(withName: "//attackNumber") as! SKLabelNode)
        let defenseNumber = (healthBarBackground.childNode(withName: "//defenseNumber") as! SKLabelNode)
        let healthBar = (healthBarBackground.childNode(withName: "//healthBar") as! SKSpriteNode)
        
        var totalAttackNumber: CGFloat = 0
        var totalDefenseNumber: CGFloat = 0
        var totalHealBarNumber: CGFloat = 0
        
        let componentList = player.equipmentList.componentList
        
        for i in 0..<componentList.count{
            if componentList[i].isWeared{
                totalAttackNumber += componentList[i].ability.attackNumber
                totalDefenseNumber += componentList[i].ability.defenseNumber
                totalHealBarNumber += componentList[i].ability.healthNumber
            }
        }
        
        totalAttackNumber += player.ability.attackNumber
        totalDefenseNumber += player.ability.defenseNumber
        totalHealBarNumber += player.ability.healthNumber
        
        attackNumber.text = "\(totalAttackNumber)"
        defenseNumber.text = "\(totalDefenseNumber)"
        healthBar.xScale = totalHealBarNumber/player.fullBlood
        
        
        
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



