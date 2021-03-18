//
//  TreeScene.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/18.
//

import Foundation
import SpriteKit

class TreeScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var showButton: MSButtonNode!
    var healthBarBackground: SKSpriteNode!
    var timer: Timer?
    
    var groundList = [[GroundNode]]()
    let groundCol = 9
    let groundRow = 5
    
    var eachFrame: TimeInterval = 1/60
    var sinceStart: TimeInterval = 0
    
    var monsterList = [Monster]()
    
    var debugButton : MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        player = Player(scene: self)
        addChild(player)
        
        showButton = (self.childNode(withName: "showButton") as! MSButtonNode)
        setupShowButton()
        
        debugButton = (self.childNode(withName: "debugButton") as! MSButtonNode)
        debugButton.selectedHandler = {
            guard let skView = self.view as SKView? else {
                print("Could not get Skview")
                return
            }
            /* Load Game scene */
            guard let scene = TreeScene(fileNamed: "TreeScene") else {
                print("Could not load CaveScene")
                return
            }
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
        
        healthBarBackground = (self.childNode(withName: "healthBarBackground") as! SKSpriteNode)
        
        setupAllGround()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //set player position when touch
        player.playerHandler(position: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        countPlayerAbility(healthBarBackground: healthBarBackground, player: player)
        
        sinceStart += eachFrame
        
        setupMonster()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
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
    
    func setupAllGround(){
        
        let oringinPos = CGPoint(x: 110, y: 102.5)
        
        for y in 0..<groundRow {
            groundList.append([])
            for x in 0..<groundCol{
                
                let newType = GroundType.getRadom()
                var newGround : GroundNode!
                
                
                //0 0 will be dirt
                if(x==0&&y==0){
                    newGround = Dirt()
                    newGround.groundType = .dirt
                    newGround.position = oringinPos
                }else{
                    switch newType {
                    case .dirt:
                        newGround = Dirt()
                    case .rock:
                        newGround = Rock()
                    case .wood:
                        newGround = Wood()
                    }
                    
                    newGround.groundType = newType
                    newGround.position = oringinPos + CGPoint(x: x*60, y: y*45)
                }
                
                addChild(newGround)
                groundList[y].append(newGround)
                
            }
        }
        
        for y in 0..<groundRow{
            for x in 0..<groundCol{
                //setting top
                if (y==4){groundList[y][x].top = nil}
                else{groundList[y][x].top = groundList[y+1][x]}
                //setting bottom
                if (y==0){groundList[y][x].bottom = nil}
                else{groundList[y][x].bottom = groundList[y-1][x]}
                
                //setting right
                if(x==8){groundList[y][x].right = nil}
                else{groundList[y][x].right = groundList[y][x+1]}
                //setting left
                if(x==0){groundList[y][x].left = nil}
                else{groundList[y][x].left = groundList[y][x-1]}
            }
        }
        
        //groundList[0][0] = Dirt()
        groundList[0][0].isDigged = true
        //groundList[0][0].alpha = 0.5
        
    }
    
    func setupMonster()  {
        if(sinceStart > 6){
            let oringinPos = CGPoint(x: 110, y: 102.5)
            //furry will born in dirt every minute with 30% chance
            //monsterList has a list of monster object,
            for y in 0..<groundRow {
                for x in 0..<groundCol{
                    
                    if(Int.random(in: 0..<100)<5 && groundList[y][x].groundType == GroundType.dirt){
                        //check if already exist
                        if (xyHasMonster(x: x,y: y)){return}
                        //ant position won't born monster
                        if(groundList[y][x].frame.contains(player.position)){return}
                        
                        let newMonster = Furry()
                        newMonster.isAlived = true
                        newMonster.monsterPositionX = x
                        newMonster.monsterPositionY = y
                        newMonster.mosterType = MonsterType.furry
                        newMonster.position = oringinPos + CGPoint(x: x*60, y: y*45)
                        //newMonster.move(toParent: groundList[y][x])
                        monsterList.append(newMonster)
                        addChild(newMonster)
                        print("add one monster!")
                        
                    }
                    
                }
            }
            sinceStart = 0
        }
    }
    
    func xyHasMonster(x: Int, y: Int) -> Bool {
        var hasMonster: Bool = false
        for i in 0..<monsterList.count{
            
            if(monsterList[i].monsterPositionX == x && monsterList[i].monsterPositionY == y && monsterList[i].isAlived){
                hasMonster = true
                continue
            }else{
                hasMonster = false
            }
        }
        return hasMonster
    }
}
