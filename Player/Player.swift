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
    var materialList: MaterialList!
    var plantCardList: PlantCardList!
    
    var ability: Abiltiy!
    
    var timer: Timer?
    
    
    
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
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "nakedAnt_2")
        super.init(texture: texture, color: .clear , size: bodySize)
        
        self.playerState = .idle
        self.zPosition = 2
        self.position = bornPosition
        self.homeScene = scene
        self.isUserInteractionEnabled = true
        //declare the basic component
        equipmentList = EquipmentList()
        materialList = MaterialList()
        plantCardList = PlantCardList()
        
        //setup physicbody
        self.physicsBody = SKPhysicsBody(rectangleOf: bodySize)
        self.physicsBody!.affectedByGravity = false
        //self.physicsBody!.isDynamic = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = 1
        self.physicsBody!.contactTestBitMask = 14
        self.physicsBody!.collisionBitMask = 0
        
        
        
        //add the initial plant card
        let flowerTexture = SKTexture(imageNamed: "flower")
        let flowerPlantCard = PlantCard(texture: flowerTexture, scene: homeScene)
        flowerPlantCard.name = "flower"
        plantCardList.addComponent(component: flowerPlantCard)
        
        //add the initail material
        let appleTexture = SKTexture(imageNamed: "apple")
        let appleMaterial = Material(texture: appleTexture, scene: homeScene)
        appleMaterial.name = "apple"
        materialList.addComponent(component: appleMaterial)
        

        //declare ability
        self.ability = Abiltiy(attackNumber: 20, defenseNumber: 20, healthNumber: 100)
        
        //add the initial equipment
        //shoes
        let shoes_1Texture = SKTexture(imageNamed: "shoes_1")
        let shoes_1Ability = Abiltiy(attackNumber: 4, defenseNumber: 1, healthNumber: 13)
        let shoes_1Equipment = Equipment(texture: shoes_1Texture, type: .shoes, scene: homeScene, ability: shoes_1Ability)
        shoes_1Equipment.name = "shoes_1"
        equipmentList.addComponent(component: shoes_1Equipment)
        
        //shoes
        let shoes_2Texture = SKTexture(imageNamed: "shoes_2")
        let shoes_2Ability = Abiltiy(attackNumber: 9, defenseNumber: 2, healthNumber: 19)
        let shoes_2Equipment = Equipment(texture: shoes_2Texture, type: .shoes, scene: homeScene, ability: shoes_2Ability)
        shoes_2Equipment.name = "shoes_2"
        equipmentList.addComponent(component: shoes_2Equipment)
        
        
        
        //weapon
        let weapon_1Texture = SKTexture(imageNamed: "weapon_1")
        let weapon_1Ability = Abiltiy(attackNumber: 5, defenseNumber: 9, healthNumber: 7)
        let weapon_1Equipment = Equipment(texture: weapon_1Texture, type: .weapon, scene: homeScene, ability: weapon_1Ability)
        weapon_1Equipment.name = "weapon_1"
        equipmentList.addComponent(component: weapon_1Equipment)
        
        //weapon
        let weapon_2Texture = SKTexture(imageNamed: "weapon_2")
        let weapon_2Ability = Abiltiy(attackNumber: 9, defenseNumber: 9, healthNumber: 21)
        let weapon_2Equipment = Equipment(texture: weapon_2Texture, type: .weapon, scene: homeScene, ability: weapon_2Ability)
        weapon_2Equipment.name = "weapon_2"
        equipmentList.addComponent(component: weapon_2Equipment)
        
        //armor
        let armor_1Texture = SKTexture(imageNamed: "armor_1")
        let armor_1Ability = Abiltiy(attackNumber: 4, defenseNumber: 6, healthNumber: 12)
        let armor_1Equipment = Equipment(texture: armor_1Texture, type: .armor, scene: homeScene, ability: armor_1Ability)
        armor_1Equipment.name = "armor_1"
        equipmentList.addComponent(component: armor_1Equipment)
        
        //armor
        let armor_2Texture = SKTexture(imageNamed: "armor_2")
        let armor_2Ability = Abiltiy(attackNumber: 9, defenseNumber: 9, healthNumber: 12)
        let armor_2Equipment = Equipment(texture: armor_2Texture, type: .armor, scene: homeScene, ability: armor_2Ability)
        armor_2Equipment.name = "armor_2"
        equipmentList.addComponent(component: armor_2Equipment)
        
        //helmet
        let helmet_1Texture = SKTexture(imageNamed: "helmet_1")
        let helmet_1Ability = Abiltiy(attackNumber: 5, defenseNumber: 2, healthNumber: 10)
        let helmet_1Equipment = Equipment(texture: helmet_1Texture, type: .helmet, scene: homeScene, ability: helmet_1Ability)
        helmet_1Equipment.name = "helmet_1"
        equipmentList.addComponent(component: helmet_1Equipment)
        
        //helmet
        let helmet_2Texture = SKTexture(imageNamed: "helmet_2")
        let helmet_2Ability = Abiltiy(attackNumber: 8, defenseNumber: 5, healthNumber: 19)
        let helmet_2Equipment = Equipment(texture: helmet_2Texture, type: .helmet, scene: homeScene, ability: helmet_2Ability)
        helmet_2Equipment.name = "helmet_2"
        equipmentList.addComponent(component: helmet_2Equipment)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            if (self.position.x <= position.x) {
                self.isMoving = false
                self.playerState = .idle
                timer.invalidate()
            }
        }
    }
    
    @objc func playerGoingRight(timer: Timer) {
        let position = timer.userInfo as! CGPoint
        if(self.isMoving){
            self.position.x += self.playerMoveDistance
            if (self.position.x >= position.x) {
                self.isMoving = false
                self.playerState = .idle
                timer.invalidate()
            }
        }
    }
}


