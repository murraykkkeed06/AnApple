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
    case goingUp
    case goingDown
}

class Player: SKSpriteNode {
    
    static var playerPosition: CGPoint!
    static var playerStartFrame: TimeInterval = 0
    
    var homeScene: SKScene!
    //player move distance per 0.01 sec
    let playerMoveDistance: CGFloat = 1
    //full blood
    let fullBlood: CGFloat = 500
    let bornPosition: CGPoint = CGPoint(x: 110, y: 102.5)
    
    var isMoving = false
    
    let bodySize : CGSize = CGSize(width: 40, height: 40)
    //component
    var equipmentList: EquipmentList!
    //var materialList: MaterialList!
    var materialBag: MaterialBag!
    //var plantCardList: PlantCardList!
    
    var plantCardBag: PlantCardBag!
    
    var equipmentBag: EquipmentBag!
    var showButton : MSButtonNode!
    
    var ability: Abiltiy!
    
    var timer: Timer?
    
    var stopAfterSecond: TimeInterval = 3
    
    var attackInterval: TimeInterval = 2
    
    private var _playerState: PlayerState!
    var playerState: PlayerState {
        set{
            self.removeAllActions()
            //self.position.y = bornPosition.y
            _playerState = newValue
            switch newValue {
            case .goingLeft:
                self.physicsBody?.affectedByGravity = true
                self.run(SKAction(named: "playerGoingLeft")!)
            case .goingRight:
                self.physicsBody?.affectedByGravity = true
                self.run(SKAction(named: "playerGoingRight")!)
            case .goingUp:
                self.physicsBody?.affectedByGravity = false
                self.run(SKAction(named: "playerGoingUp")!)
            case .goingDown:
                self.physicsBody?.affectedByGravity = false
                self.run(SKAction(named: "playerGoingUp")!)
            case .idle:
                //self.run(SKAction(named: "playerIdle")!)
               // self.physicsBody?.affectedByGravity = true
                self.removeAllActions()
            }
        }
        get{
            return _playerState
        }
    }
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "nakedAnt_2")
        super.init(texture: texture, color: .clear , size: bodySize)
        
        self.playerState = .idle
        self.zPosition = 3
        self.position = bornPosition
        self.homeScene = scene
        self.name = "player"
        //declare ability
        self.ability = Abiltiy(attackNumber: 20, defenseNumber: 20, healthNumber: 100)
        //self.isUserInteractionEnabled = true
        //declare the basic component
        equipmentList = EquipmentList()
        //materialList = MaterialList()
        //plantCardList = PlantCardList()
        plantCardBag = (self.homeScene.childNode(withName: "plantCardBag") as! PlantCardBag)
        materialBag = (self.homeScene.childNode(withName: "materialBag") as! MaterialBag)
        equipmentBag = (self.homeScene.childNode(withName: "equipmentBag") as! EquipmentBag)
        showButton = (self.homeScene.childNode(withName: "showButton") as! MSButtonNode)
        //setup physicbody
        self.physicsBody = SKPhysicsBody(rectangleOf: bodySize)
        self.physicsBody!.affectedByGravity = true
        //self.physicsBody!.isDynamic = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = 1
        self.physicsBody!.contactTestBitMask = 14
        self.physicsBody!.collisionBitMask = 16
        
        
        
        //add plantcard
        plantCardBag.addPlantCard(plantCard: Flower())
        plantCardBag.addPlantCard(plantCard: WoodBreaker())
        plantCardBag.addPlantCard(plantCard: StoneBreaker())
        plantCardBag.addPlantCard(plantCard: ToolBoxCard())
        
        //add material
        materialBag.addMaterial(material: Apple())
        materialBag.addMaterial(material: Apple())
        //materialBag.addMaterial(material: Seed())
        //materialBag.addMaterial(material: Egg())

        
        
        //add equipment
        let shoes_1 = Shoes(version: "1", equipmentBag: equipmentBag, showButton: showButton)
        //shoes_1.isWeared = false
//        let shoes_2 = Shoes(version: "2", equipmentBag: equipmentBag, showButton: showButton)
        equipmentList.addComponent(component: shoes_1)
        //equipmentList.addComponent(component: shoes_2)
        
        let weapon_1 = Weapon(version: "1", equipmentBag: equipmentBag, showButton: showButton)
        //weapon_1.isWeared = false
//        let weapon_2 = Weapon(version: "2", equipmentBag: equipmentBag, showButton: showButton)
        equipmentList.addComponent(component: weapon_1)
        //equipmentList.addComponent(component: weapon_2)
        
        let armor_1 = Armor(version: "1", equipmentBag: equipmentBag, showButton: showButton)
        //armor_1.isWeared = false
//        let armor_2 = Armor(version: "2", equipmentBag: equipmentBag, showButton: showButton)
        equipmentList.addComponent(component: armor_1)
//        equipmentList.addComponent(component: armor_2)
        
        let helmet_1 = Helmet(version: "1", equipmentBag: equipmentBag, showButton: showButton)
        //helmet_1.isWeared = false
//        let helmet_2 = Helmet(version: "2", equipmentBag: equipmentBag, showButton: showButton)
        equipmentList.addComponent(component: helmet_1)
//        equipmentList.addComponent(component: helmet_2)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func climb(position: CGPoint)  {
        if(self.isMoving){timer?.invalidate()}
        
        //moving down
        if(position.y < self.position.y){
            self.isMoving = true
            self.playerState = .goingDown
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,selector: #selector(playerGoingDown), userInfo: position, repeats: true)
        }
        //moviing up
        if(position.y>self.position.y){
            self.isMoving = true
            self.playerState = .goingUp
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,selector: #selector(playerGoingUp), userInfo: position, repeats: true)
        }
    }
    
    @objc func playerGoingDown(timer: Timer) {
        let position = timer.userInfo as! CGPoint
        if(self.isMoving){
            self.position.y -= self.playerMoveDistance
                        
            // suscess to get to pos
            if (self.position.y <= position.y || self.position.y <= 100) {
                self.isMoving = false
                self.playerState = .idle
                timer.invalidate()
                Player.playerStartFrame = 0
                
            // fail to get to pos in 10 seconds
            }else if (Player.playerStartFrame > self.stopAfterSecond){
                timer.invalidate()
                Player.playerStartFrame = 0
                playerState = .idle
            }
        }
    }
    
    @objc func playerGoingUp(timer: Timer) {
        let position = timer.userInfo as! CGPoint
        if(self.isMoving){
            self.position.y += self.playerMoveDistance
            if (self.position.y >= position.y || self.position.y >= 285) {
                self.isMoving = false
                self.playerState = .idle
                timer.invalidate()
                Player.playerStartFrame = 0
            }else if (Player.playerStartFrame > self.stopAfterSecond){
                timer.invalidate()
                Player.playerStartFrame = 0
                playerState = .idle
            }
        }
    }
    
    
    //handle movement when user touch began
    func playerHandler(position: CGPoint, boundage: Bool) {
        //check whether out of place
        if boundage {
            if position.x < 80 || position.x > 620 || position.y < 80 || position.y > 305{
                return
            }
        }
        
        //get another touch when player is moving
        if(self.isMoving){timer?.invalidate()}
        //moving left
        if(position.x < self.position.x){
            self.isMoving = true
            self.playerState = .goingLeft
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,selector: #selector(playerGoingLeft), userInfo: position, repeats: true)
        }
        //moviing right
        if(position.x>self.position.x){
            self.isMoving = true
            self.playerState = .goingRight
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,selector: #selector(playerGoingRight), userInfo: position, repeats: true)
        }
       
        
    }
    @objc func playerGoingLeft(timer: Timer) {
        let position = timer.userInfo as! CGPoint
        if(self.isMoving){
            self.position.x -= self.playerMoveDistance
            
            
            
            // suscess to get to pos
            if (self.position.x <= position.x || self.position.x <= 100) {
                self.isMoving = false
                self.playerState = .idle
                timer.invalidate()
                Player.playerStartFrame = 0
                
            // fail to get to pos in 10 seconds
            }else if (Player.playerStartFrame > self.stopAfterSecond){
                timer.invalidate()
                Player.playerStartFrame = 0
                playerState = .idle
            }
        }
    }
    
    @objc func playerGoingRight(timer: Timer) {
        let position = timer.userInfo as! CGPoint
        if(self.isMoving){
            self.position.x += self.playerMoveDistance
            if (self.position.x >= position.x || self.position.x >= 620) {
                self.isMoving = false
                self.playerState = .idle
                timer.invalidate()
                Player.playerStartFrame = 0
            }else if (Player.playerStartFrame > self.stopAfterSecond){
                timer.invalidate()
                Player.playerStartFrame = 0
                playerState = .idle
            }
        }
    }
}


