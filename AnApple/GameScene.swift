//
//  GameScene.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var showButton: MSButtonNode!
    var healthBarBackground: SKSpriteNode!
    var timer: Timer?
    var movingNode: Material!
    var homeNode: SKSpriteNode!
    var workshopNode : SKSpriteNode!
    var treeNode: SKSpriteNode!
        override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        player = Player(scene: self)
        //equipmentBag = (self.childNode(withName: "equipmentBag") as! EquipmentBag)
        addChild(player)
        //storagebag is included in a button
        //storageBag = (self.childNode(withName: "//storageBag") as! StorageBag)
        showButton = (self.childNode(withName: "showButton") as! MSButtonNode)
        setupShowButton()
        
        
        homeNode = (self.childNode(withName: "home") as! SKSpriteNode)
        workshopNode = (self.childNode(withName: "workshop") as! SKSpriteNode)
        treeNode = (self.childNode(withName: "tree") as! SKSpriteNode)
            
        healthBarBackground = (self.childNode(withName: "healthBarBackground") as! SKSpriteNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        //set player position when touch
        player.playerHandler(position: location)
        
//        if nodeAtPoint.name == "apple" {
//            movingNode = (nodeAtPoint as! Material)
//            movingNode.move(toParent: self)
//        }
        
        //print("\(nodeAtPoint.name)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //movingNode.position = location
    }
    
    override func update(_ currentTime: TimeInterval) {
        countPlayerAbility(healthBarBackground: healthBarBackground, player: player)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        handleBeginSelection(nodeA: nodeA!, nodeB: nodeB!)

    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        handleEndSelection(nodeA: nodeA!, nodeB: nodeB!)
       
        
        
    }
    
    
    
    func handleBeginSelection(nodeA: SKNode, nodeB: SKNode) {
        //when contact tree
        if nodeA.name == "tree" || nodeB.name == "tree" {
            let arrow = (self.treeNode.childNode(withName: "arrow") as! MSButtonNode)
            arrow.run(SKAction(named: "playerIdle")!)
            arrow.selectedHandler = {
                self.loadTreeScene()
            }
        }
        
        //when contact home
        if nodeA.name == "home" || nodeB.name == "home" {
            
            homeNode.run(SKAction(named: "selected")!)
            
            let enterButton = (homeNode.childNode(withName: "homeEnterButton") as! MSButtonNode)
            enterButton.position = CGPoint(x: 0, y: 50)
            enterButton.run(SKAction.sequence([SKAction(named: "buttonShow")!,SKAction(named: "playerIdle")!]))
            
            let homeScreen = (homeNode.childNode(withName: "homeScreen") as! SKSpriteNode)

            enterButton.selectedHandler = {
                homeScreen.position = CGPoint(x: 135, y: 79)
            }
            
            let backButton = (homeScreen.childNode(withName: "//homeBackButton") as! MSButtonNode)
            backButton.selectedHandler = {
                homeScreen.position = CGPoint(x: 999, y: 999)
            }
        }
        
        //when contact workshop
        if nodeA.name == "workshop" || nodeB.name == "workshop" {
            
            workshopNode.run(SKAction(named: "selected")!)
            
            let enterButton = (workshopNode.childNode(withName: "workshopEnterButton") as! MSButtonNode)
            enterButton.position = CGPoint(x: 0, y: 50)
            enterButton.run(SKAction.sequence([SKAction(named: "buttonShow")!,SKAction(named: "playerIdle")!]))
            
            let workshopScreen = (workshopNode.childNode(withName: "workshopScreen") as! SKSpriteNode)
            
            enterButton.selectedHandler = {
                workshopScreen.position = CGPoint(x: 16, y: 93)
            }
            
            let backButton = (workshopScreen.childNode(withName: "//workshopBackButton") as! MSButtonNode)
            backButton.selectedHandler = {
                workshopScreen.position = CGPoint(x: 999, y: 999)
                
            }
        }
    }
    
    
    func handleEndSelection(nodeA: SKNode, nodeB: SKNode)  {
        
        //when end contact tree
        if nodeA.name == "tree" || nodeB.name == "tree" {
            let arrow = (self.treeNode.childNode(withName: "arrow") as! MSButtonNode)
            arrow.removeAllActions()
        }
        
        //when stop contact home
        if nodeA.name == "home" || nodeB.name == "home" {

            let enterButton = (homeNode.childNode(withName: "homeEnterButton") as! MSButtonNode)
            enterButton.removeAllActions()
            enterButton.run(SKAction(named: "buttonHide")!)
        }
        
        //when stop contact workshop
        if nodeA.name == "workshop" || nodeB.name == "workshop" {
            let enterButton = (workshopNode.childNode(withName: "workshopEnterButton") as! MSButtonNode)
            enterButton.removeAllActions()
            enterButton.run(SKAction(named: "buttonHide")!)
        }
    }
    
    
    
    func countPlayerAbility(healthBarBackground: SKSpriteNode, player: Player) {
        let attackNumber = (healthBarBackground.childNode(withName: "//playerAttackNumber") as! SKLabelNode)
        let defenseNumber = (healthBarBackground.childNode(withName: "//playerDefenseNumber") as! SKLabelNode)
        let healthBar = (healthBarBackground.childNode(withName: "//playerHealthBar") as! SKSpriteNode)
        
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
                self.childNode(withName: "//detailDisplay")?.isHidden = true
            case .hide:
                let action = SKAction.moveTo(x: 495, duration: 1)
                action.timingMode = .easeInEaseOut
                self.showButton.run(action)
                self.showButton.buttonState = .show
                
            }
        }
    }
    
    func loadTreeScene() {
        if let view = self.view as SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = TreeScene(fileNamed: "TreeScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
    
    
    
}



