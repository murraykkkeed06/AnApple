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
        
        
        
        //add the initial plant card
        let flower_1Texture = SKTexture(imageNamed: "flower")
        let flower_1PlantCard = PlantCard(texture: flower_1Texture)
        flower_1PlantCard.name = "flowerCard"
        plantCardBag.addPlantCard(plantCard: flower_1PlantCard)
        //plantCardList.addComponent(component: flower_1PlantCard)
        
        
//        //add the initial plant card
//        let flower_2Texture = SKTexture(imageNamed: "flower")
//        let flower_2PlantCard = PlantCard(texture: flower_2Texture, scene: homeScene)
//        flower_2PlantCard.name = "flowerCard"
//        plantCardList.addComponent(component: flower_2PlantCard)
//
//        //add the initial plant card
//        let flower_3Texture = SKTexture(imageNamed: "flower")
//        let flower_3PlantCard = PlantCard(texture: flower_3Texture, scene: homeScene)
//        flower_3PlantCard.name = "flowerCard"
//        plantCardList.addComponent(component: flower_3PlantCard)
//
//        //add the initial plant card
//        let flower_4Texture = SKTexture(imageNamed: "flower")
//        let flower_4PlantCard = PlantCard(texture: flower_4Texture, scene: homeScene)
//        flower_4PlantCard.name = "flowerCard"
//        plantCardList.addComponent(component: flower_4PlantCard)
        
        //add the initail material
        let apple_1Texture = SKTexture(imageNamed: "apple")
        let apple_1Material = Material(texture: apple_1Texture)
        apple_1Material.name = "apple"
        apple_1Material.ability = Abiltiy(attackNumber: 0, defenseNumber: 0, healthNumber: 100)
        materialBag.addMaterial(material: apple_1Material)
        //materialList.addComponent(component: apple_1Material)
        
        //add the initail material
        let apple_2Texture = SKTexture(imageNamed: "apple")
        let apple_2Material = Material(texture: apple_2Texture)
        apple_2Material.name = "apple"
        apple_2Material.ability = Abiltiy(attackNumber: 0, defenseNumber: 0, healthNumber: 100)
        //materialList.addComponent(component: apple_2Material)
        materialBag.addMaterial(material: apple_2Material)

        //declare ability
        self.ability = Abiltiy(attackNumber: 20, defenseNumber: 20, healthNumber: 100)
        
        //add the initial equipment
        //shoes
        let shoes_1Texture = SKTexture(imageNamed: "shoes_1")
        let shoes_1Ability = Abiltiy(attackNumber: 4, defenseNumber: 1, healthNumber: 13)
        let shoes_1Equipment = Equipment(texture: shoes_1Texture, type: .shoes, ability: shoes_1Ability,equipmentBag: equipmentBag, showButton: showButton)
        shoes_1Equipment.name = "shoes_1"
        equipmentList.addComponent(component: shoes_1Equipment)
        
        //shoes
        let shoes_2Texture = SKTexture(imageNamed: "shoes_2")
        let shoes_2Ability = Abiltiy(attackNumber: 9, defenseNumber: 2, healthNumber: 19)
        let shoes_2Equipment = Equipment(texture: shoes_2Texture, type: .shoes,  ability: shoes_2Ability,equipmentBag: equipmentBag,showButton: showButton)
        shoes_2Equipment.name = "shoes_2"
        equipmentList.addComponent(component: shoes_2Equipment)
        
        
        
        //weapon
        let weapon_1Texture = SKTexture(imageNamed: "weapon_1")
        let weapon_1Ability = Abiltiy(attackNumber: 5, defenseNumber: 9, healthNumber: 7)
        let weapon_1Equipment = Equipment(texture: weapon_1Texture, type: .weapon,  ability: weapon_1Ability,equipmentBag: equipmentBag,showButton: showButton)
        weapon_1Equipment.name = "weapon_1"
        equipmentList.addComponent(component: weapon_1Equipment)
        
        //weapon
        let weapon_2Texture = SKTexture(imageNamed: "weapon_2")
        let weapon_2Ability = Abiltiy(attackNumber: 9, defenseNumber: 9, healthNumber: 21)
        let weapon_2Equipment = Equipment(texture: weapon_2Texture, type: .weapon, ability: weapon_2Ability,equipmentBag: equipmentBag,showButton: showButton)
        weapon_2Equipment.name = "weapon_2"
        equipmentList.addComponent(component: weapon_2Equipment)
        
        //armor
        let armor_1Texture = SKTexture(imageNamed: "armor_1")
        let armor_1Ability = Abiltiy(attackNumber: 4, defenseNumber: 6, healthNumber: 12)
        let armor_1Equipment = Equipment(texture: armor_1Texture, type: .armor,  ability: armor_1Ability,equipmentBag: equipmentBag,showButton: showButton)
        armor_1Equipment.name = "armor_1"
        equipmentList.addComponent(component: armor_1Equipment)
        
        //armor
        let armor_2Texture = SKTexture(imageNamed: "armor_2")
        let armor_2Ability = Abiltiy(attackNumber: 9, defenseNumber: 9, healthNumber: 12)
        let armor_2Equipment = Equipment(texture: armor_2Texture, type: .armor,  ability: armor_2Ability,equipmentBag: equipmentBag,showButton: showButton)
        armor_2Equipment.name = "armor_2"
        equipmentList.addComponent(component: armor_2Equipment)
        
        //helmet
        let helmet_1Texture = SKTexture(imageNamed: "helmet_1")
        let helmet_1Ability = Abiltiy(attackNumber: 5, defenseNumber: 2, healthNumber: 10)
        let helmet_1Equipment = Equipment(texture: helmet_1Texture, type: .helmet, ability: helmet_1Ability,equipmentBag: equipmentBag,showButton: showButton)
        helmet_1Equipment.name = "helmet_1"
        equipmentList.addComponent(component: helmet_1Equipment)
        
        //helmet
        let helmet_2Texture = SKTexture(imageNamed: "helmet_2")
        let helmet_2Ability = Abiltiy(attackNumber: 8, defenseNumber: 5, healthNumber: 19)
        let helmet_2Equipment = Equipment(texture: helmet_2Texture, type: .helmet,  ability: helmet_2Ability,equipmentBag: equipmentBag,showButton: showButton)
        helmet_2Equipment.name = "helmet_2"
        equipmentList.addComponent(component: helmet_2Equipment)
        
        
        
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


