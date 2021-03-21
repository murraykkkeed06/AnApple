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
    var sinceMonsterBorn: TimeInterval = 0
    
    var monsterList = [Monster]()
    
    
    var debugButton : MSButtonNode!
    var vineButton: MSButtonNode!
    
    var movingNode: SKSpriteNode!
    var originPosition: CGPoint!
    
    var materialBag: MaterialBag!
    var plantCardBag: PlantCardBag!
    var equipmentBag: EquipmentBag!
   
    
    var ladderList = [Ladder]()
    
    var fightScreen: FightScreen!
    
    var sun: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        //player = Player(scene: self)
        //saddChild(player)
        player.move(toParent: self)
        player.position = CGPoint(x: 110, y: 102.5)
        
        materialBag.move(toParent: self)
        materialBag.position = CGPoint(x: 178, y: 341)
        plantCardBag.move(toParent: self)
        plantCardBag.position = CGPoint(x: 178, y: 27)
        equipmentBag.move(toParent: self)
        equipmentBag.position = CGPoint(x: 27, y: 186)
        showButton.move(toParent: self)
        showButton.position = CGPoint(x: 494, y: 258)
        
        sun = (self.childNode(withName: "//sun") as! SKSpriteNode)
        
        fightScreen = (self.childNode(withName: "fightScreen") as! FightScreen)
        
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
            scene.player = self.player
            scene.materialBag = self.materialBag
            scene.equipmentBag = self.equipmentBag
            scene.showButton = self.showButton
            scene.plantCardBag = self.plantCardBag
            skView.presentScene(scene)
        }
        
        healthBarBackground = (self.childNode(withName: "healthBarBackground") as! SKSpriteNode)
        
        setupAllGround()
        
        setDirtDrop()
        
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
        handleWoodBreaker(phase: "began", location: location)
        handleStoneBreaker(phase: "began", location: location)
        //handle plant card to ground
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //drag apple to player
        handleApple(phase: "moved", location: location)
        handleLadder(phase: "moved", location: location)
        handleWoodBreaker(phase: "moved", location: location)
        handleStoneBreaker(phase: "moved", location: location)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //drag apple to player
        handleApple(phase: "ended", location: location)
        handleLadder(phase: "ended", location: location)
        handleWoodBreaker(phase: "ended", location: location)
        handleStoneBreaker(phase: "ended", location: location)
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //set player x y in groundnode class
        Player.playerPosition = player.position
        
        countPlayerAbility(healthBarBackground: healthBarBackground, player: player)
        checkMonsterGravity()
        
        sinceStart += eachFrame
        sinceMonsterBorn += eachFrame
        Player.playerStartFrame += eachFrame
        
        setupMonster()
        
        sunMoving()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //let nodeA = contact.bodyA.node
        //let nodeB = contact.bodyB.node
        if let nodeA = contact.bodyA.node  {
            if let nodeB = contact.bodyB.node {
        fightScreen.handleFight(nodeA: nodeA, nodeB: nodeB,monsterList: monsterList)
        playerPickUp(nodeA: nodeA, nodeB: nodeB)
            }
        }
    }
    
    func playerPickUp(nodeA: SKNode, nodeB: SKNode)  {
        pickUpSeed(nodeA: nodeA, nodeB: nodeB)
        pickUpEgg(nodeA: nodeA, nodeB: nodeB)
        pickUpHelmet(nodeA: nodeA, nodeB: nodeB)
    }
    
    func pickUpHelmet(nodeA: SKNode, nodeB: SKNode){
        //pick up seed
        var helmet: Helmet!
        if (nodeA.name == "helmet" && nodeB.name == "player"){
            player = nodeB as? Player
            helmet = nodeA as? Helmet
        }else if nodeA.name == "player" && nodeB.name == "helmet" {
            player = nodeA as? Player
            helmet = nodeB as? Helmet
        }else { return }
        
        helmet.removeFromParent()
        let newHelmet = Helmet(version: "2", equipmentBag: equipmentBag, showButton: showButton)
        player.equipmentList.addComponent(component: newHelmet)
        //newHelmet.physicsBody = nil
        
    }
    
    
    
    func pickUpSeed(nodeA: SKNode, nodeB: SKNode){
        //pick up seed
        var seed: Seed!
        if (nodeA.name == "seed" && nodeB.name == "player"){
            player = nodeB as? Player
            seed = nodeA as? Seed
        }else if nodeA.name == "player" && nodeB.name == "seed" {
            player = nodeA as? Player
            seed = nodeB as? Seed
        }else { return }
        
        seed.removeFromParent()
        let newSeed = Seed()
        //newSeed.physicsBody = nil
        materialBag.addMaterial(material: newSeed)
    }
    
    func pickUpEgg(nodeA: SKNode, nodeB: SKNode) {
        //pick up egg
        var egg: Egg!
        if (nodeA.name == "egg" && nodeB.name == "player"){
            player = nodeB as? Player
            egg = nodeA as? Egg
        }else if nodeA.name == "player" && nodeB.name == "egg" {
            player = nodeA as? Player
            egg = nodeB as? Egg
        }else { return }
        
        egg.removeFromParent()
        let newEgg = Egg()
        //newEgg.physicsBody = nil
        materialBag.addMaterial(material: newEgg)
    }
    
    func checkMonsterGravity() {
        for i in 0..<monsterList.count{
            let position = monsterList[i].position
            if let groundNode = xyGroundNode(location: position){
                if groundNode.isDigged{
                    //if monsterList[i].isDiggedOut {return}
                    //monsterList[i].isDiggedOut = true
                    if !monsterList[i].isDiggedOut {
                        monsterList[i].physicsBody?.affectedByGravity = true
                        monsterList[i].physicsBody?.collisionBitMask = 16
                        //monsterList[i].isGoingRight = true
                        //monsterList[i].moveAround(groundList: groundList)
                        monsterList[i].run(SKAction(named: "moveAround")!)
                        monsterList[i].isDiggedOut = true
                    }
                }
            }
        }
    }
    
    
    func sunMoving() {
        sun.position.x = CGFloat(sinceStart)
        if sinceStart>100 {
            sinceStart = 0
        }
    }
    
    func handleClimb(location: CGPoint) {
        let nodeAtPoint = atPoint(location)
        if !positionInRange(position: location){return}
        //let groundNode = xyGroundNode(location: location)
        
        if let ladder = playerOnLadder()  {
            if let groundNode = xyGroundNode(location: location) {
                if let bottom = groundNode.bottom {
                    if nodeAtPoint.name == "ladder" && nodeAtPoint.frame.contains(player.position){
                        player.climb(position: location)
                    }else if (groundNode.isDigged &&
                                ladder.frame.contains(bottom.position) ){
                        player.climb(position: location)
                    }
                }
            }
        }
        
        
    }
    
    //|| (groundNode.isDigged && playerOnLadder )
    
    
    func playerOnLadder() -> Ladder? {
        //check player is on ladder
        var ladder: Ladder!
        for i in 0..<ladderList.count{
            if ladderList[i].frame.contains(player.position){
                ladder = ladderList[i]
                break
            }
            ladder = nil
        }
        return ladder
    }
    
    func positionInRange(position: CGPoint) -> Bool {
        var inRange = false
        
        if position.x > 80 && position.x < 620  && position.y < 305 && position.y > 80 {inRange = true}
        
        return inRange
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
                    if let groundNode = xyGroundNode(location: location) {
                        //player.plantCardList.removeComponent(name: "flowerCard")
                        plantCardBag.removePlantCard(name: "flowerCard")
                        //movingNode.removeFromParent()
                        let ladder = Ladder()
                        
                        ladder.position = groundNode.position - CGPoint(x: 0, y: 22.5)
                        ladderList.append(ladder)
                        addChild(ladder)
                    }
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
    
    func handleWoodBreaker(phase: String, location: CGPoint) {
        let nodeAtPoint = atPoint(location)
        if nodeAtPoint.name == "woodBreaker"{
            switch phase {
            case "began":
                nodeAtPoint.move(toParent: self)
                originPosition = nodeAtPoint.position
                movingNode = (nodeAtPoint as! SKSpriteNode)
            case "moved":
                movingNode.position = location
            case "ended":
                
                if let groundNode = xyGroundNode(location: location){
                    if groundNode.groundType == .wood {
                        groundNode.isDigged = true
                        plantCardBag.removePlantCard(name: "woodBreaker")
                    }else {
                        movingNode.position = originPosition
                        movingNode.move(toParent: plantCardBag)
                        movingNode = nil
                    }
                }else {
                    movingNode.position = originPosition
                    movingNode.move(toParent: plantCardBag)
                    movingNode = nil
                }
                
            default:
                break
            }
            
            
        }
    }
    
    func handleStoneBreaker(phase: String, location: CGPoint) {
        let nodeAtPoint = atPoint(location)
        if nodeAtPoint.name == "stoneBreaker"{
            switch phase {
            case "began":
                nodeAtPoint.move(toParent: self)
                originPosition = nodeAtPoint.position
                movingNode = (nodeAtPoint as! SKSpriteNode)
            case "moved":
                movingNode.position = location
            case "ended":
                
                if let groundNode = xyGroundNode(location: location){
                    if groundNode.groundType == .rock {
                        groundNode.isDigged = true
                        plantCardBag.removePlantCard(name: "stoneBreaker")
                    }else {
                        movingNode.position = originPosition
                        movingNode.move(toParent: plantCardBag)
                        movingNode = nil
                    }
                }else {
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
                    //movingNode.removeFromParent()
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
                
                let newType = GroundType.getRadom(dirt: 0.6, rock: 0.2, wood: 0.2)
                var newGround : GroundNode!
                
                
                //0 0 will be dirt
                if(x==0&&y==0){
                    newGround = Dirt()
                    newGround.groundType = .dirt
                    newGround.position = oringinPos
                    newGround.gridXY = GridXY(x: 0, y: 0)
                    newGround.isDigged = true
                    // newGround.physicsBody = nil
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
        //groundList[0][0].isDigged = true
        //groundList[0][0].alpha = 0.5
        
    }
    
    
    func setDirtDrop()  {
        for y in 0..<groundRow {
            for x in 0..<groundCol{
                if groundList[y][x].groundType == .dirt {
                    groundList[y][x].diggedDrop = {
                        if Int.random(in: 0..<10)<2{
                            let seed = Seed()
                            seed.position = self.groundList[y][x].position
                            self.addChild(seed)
                        }
                        if Int.random(in: 0..<10)<2{
                            let egg = Egg()
                            egg.position = self.groundList[y][x].position
                            self.addChild(egg)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func setupMonster()  {
        
        
        
        
        if(sinceMonsterBorn > Furry.bornSecond){
            
            let oringinPos = CGPoint(x: 110, y: 102.5)
            
            for y in 0..<groundRow {
                for x in 0..<groundCol{
                    
                    if(CGFloat.random(in: 0..<100)<Furry.bornChance*100 && groundList[y][x].groundType == Furry.bornGround){
                        //check if already exist
                        if (xyHasMonster(x: x,y: y)){return}
                        //ant position won't born monster
                        if(groundList[y][x].frame.contains(player.position)){return}
                        //digged ground won't born monster
                        if groundList[y][x].isDigged {return}
                        let newMonster = Furry()
                        //newMonster.isAlived = true
                        newMonster.gridXY = GridXY(x: x, y: y)
                        newMonster.position = oringinPos + CGPoint(x: x*60, y: y*45)
                        newMonster.dieDrop = {
                            if Int.random(in: 0..<10)<8{
                                let helmet = Helmet(version: "2", equipmentBag: self.equipmentBag, showButton: self.showButton)
                                    helmet.position = newMonster.position
                                    self.addChild(helmet)
                                newMonster.hasDrop = true
                            }
                            
                            
                        }
                        //newMonster.move(toParent: groundList[y][x])
                        monsterList.append(newMonster)
                        addChild(newMonster)
                        print("add one monster!")
                        
                    }
                    
                }
            }
            sinceMonsterBorn = 0
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
    
    func xyGroundNode(location: CGPoint) -> GroundNode? {
        var groundNode: GroundNode?
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
        
        if let groundNode = xyGroundNode(location: location) {
            
            
            if let top = groundNode.top {
                if groundNode.isDigged && top.isDigged {
                    canPut = true
                }
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

