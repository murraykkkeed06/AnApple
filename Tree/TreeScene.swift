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
    var vineButton: MSButtonNode!
    
    var movingNode: SKSpriteNode!
    var originPosition: CGPoint!
    
    var materialBag: MaterialBag!
    var plantCardBag: PlantCardBag!
    
    var ladderList = [Ladder]()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        player = Player(scene: self)
        addChild(player)
        
        materialBag = (self.childNode(withName: "materialBag") as! MaterialBag)
        plantCardBag = (self.childNode(withName: "plantCardBag") as! PlantCardBag)
        
        showButton = (self.childNode(withName: "showButton") as! MSButtonNode)
        setupShowButton()
        
        vineButton = (self.childNode(withName: "vine") as! MSButtonNode)
        vineButton.selectedHandler = {
            //if not in (5,9) position
            if !self.groundList[4][8].frame.contains(self.player.position){return}
            
            guard let skView = self.view as SKView? else {
                print("Could not get Skview")
                return
            }
            /* Load Game scene */
            guard let scene = GameScene(fileNamed: "GameScene") else {
                print("Could not load CaveScene")
                return
            }
            scene.player = self.player
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
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
        player.playerHandler(position: location, boundage: true)
        //ladder climb handler
        handleClimb(location: location)
        //drag apple to player
        handleApple(phase: "began", location: location)
        handleLadder(phase: "began", location: location)
        //handle plant card to ground
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //drag apple to player
        handleApple(phase: "moved", location: location)
        handleLadder(phase: "moved", location: location)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //drag apple to player
        handleApple(phase: "ended", location: location)
        handleLadder(phase: "ended", location: location)
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //set player x y in groundnode class
        Player.playerPosition = player.position
        
        countPlayerAbility(healthBarBackground: healthBarBackground, player: player)
        
        sinceStart += eachFrame
        Player.playerStartFrame += eachFrame
        
        setupMonster()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    func handleClimb(location: CGPoint) {
        let nodeAtPoint = atPoint(location)
        if nodeAtPoint.name == "ladder" && nodeAtPoint.frame.contains(player.position){
            player.climb(position: location)
        }
    }
    
    
    func handleLadder(phase: String, location: CGPoint) {
        let nodeAtPoint = atPoint(location)
        if nodeAtPoint.name == "flowerCard"{
            switch phase {
            case "began":
                nodeAtPoint.move(toParent: self)
                originPosition = nodeAtPoint.position
                movingNode = (nodeAtPoint as! SKSpriteNode)
            case "moved":
                movingNode.position = location
            case "ended":
                if xyCanPutLadder(location: location) {
        
                    //player.plantCardList.removeComponent(name: "flowerCard")
                    plantCardBag.removePlantCard(name: "flowerCard")
                    movingNode.removeFromParent()
                    let ladder = Ladder()
                    let groundNode = xyGroundNode(location: location)
                    ladder.position = groundNode.position - CGPoint(x: 0, y: 22.5)
                    ladderList.append(ladder)
                    addChild(ladder)
                    //plantCardBag.renderPlantCard()
                } else {
                    movingNode.position = originPosition
                    movingNode.move(toParent: plantCardBag)
                    movingNode = nil
                }
            default:
                break
            }
            
            
        }
    }
    
    
    
    
    func handleApple(phase: String, location: CGPoint) {
        
        let nodeAtPoint = atPoint(location)
        if nodeAtPoint.name == "apple"{
            switch phase {
            case "began":
                nodeAtPoint.move(toParent: self)
                originPosition = nodeAtPoint.position
                movingNode = (nodeAtPoint as! SKSpriteNode)
            case "moved":
                movingNode.position = location
            case "ended":
                if nodeAtPoint.frame.contains(player.position){
                    //player.materialList.removeComponent(name: "apple")
                    materialBag.removeMaterial(name: "apple")
                    movingNode.removeFromParent()
                    let apple = movingNode as! Material
                    player.ability.healthNumber += apple.ability.healthNumber
                    //materialBag.renderMaterial()
                }else{
                    movingNode.position = originPosition
                    movingNode.move(toParent: materialBag)
                    movingNode = nil
                }
            default:
                break
                
            }
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
    
    func setupAllGround(){
        
        let oringinPos = CGPoint(x: 110, y: 102.5)
        
        for y in 0..<groundRow {
            groundList.append([])
            for x in 0..<groundCol{
                
                let newType = GroundType.getRadom(dirt: 0.7, rock: 0.2, wood: 0.1)
                var newGround : GroundNode!
                
                
                //0 0 will be dirt
                if(x==0&&y==0){
                    newGround = Dirt()
                    newGround.groundType = .dirt
                    newGround.position = oringinPos
                    newGround.gridXY = GridXY(x: 0, y: 0)
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
                    newGround.gridXY = GridXY(x: x, y: y)
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
        
        
        
        
        if(sinceStart > Furry.bornSecond){
            
            let oringinPos = CGPoint(x: 110, y: 102.5)
            
            for y in 0..<groundRow {
                for x in 0..<groundCol{
                    
                    if(CGFloat.random(in: 0..<100)<Furry.bornChance*100 && groundList[y][x].groundType == Furry.bornGround){
                        //check if already exist
                        if (xyHasMonster(x: x,y: y)){return}
                        //ant position won't born monster
                        if(groundList[y][x].frame.contains(player.position)){return}
                        
                        let newMonster = Furry()
                        newMonster.isAlived = true
                        newMonster.gridXY = GridXY(x: x, y: y)
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
            
            if(monsterList[i].gridXY.x == x && monsterList[i].gridXY.y == y && monsterList[i].isAlived){
                hasMonster = true
                continue
            }else{
                hasMonster = false
            }
        }
        return hasMonster
    }
    
    func xyGroundNode(location: CGPoint) -> GroundNode {
        var groundNode: GroundNode!
        for y in 0..<groundRow {
            for x in 0..<groundCol{
                if(groundList[y][x].frame.contains(location)){
                    groundNode = groundList[y][x]
                    break
                }
            }
        }
        return groundNode
    }
    
    
    func xyCanPutLadder(location: CGPoint) -> Bool {
        
        
        
        var canPut = false
        var groundNode: GroundNode!
        
        for y in 0..<groundRow {
            for x in 0..<groundCol{
                if(groundList[y][x].frame.contains(location)){
                    groundNode = groundList[y][x]
                    break
                }
            }
        }
        
        if let top = groundNode.top {
            if groundNode.isDigged && top.isDigged {
                canPut = true
            }
        }
        // check no ladder at location
        for i in 0..<ladderList.count{
            if ladderList[i].frame.contains(location){
                canPut = false
            }
        }
        
        
        
        return canPut
    }
    
}

