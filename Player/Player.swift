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
    
    let bornPosition: CGPoint = CGPoint(x: 300, y: 80)
    
    var isMoving = false
    
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
        super.init(texture: texture, color: .clear , size: CGSize(width: 40, height: 40))
        
        self.playerState = .idle
        self.zPosition = 1
        self.position = bornPosition
        self.homeScene = scene
        //declare the basic component
        equipmentList = EquipmentList()
        materialList = MaterialList()
        plantCardList = PlantCardList()
        

        //declare ability
        ability = Abiltiy()
        
        //add the initial equipment
        let shoes_1Texture = SKTexture(imageNamed: "shoes_1")
        let shoes_1Equipment = Equipment(texture: shoes_1Texture, type: .shoes, scene: homeScene)
        shoes_1Equipment.isWeared = true
        equipmentList.addComponent(component: shoes_1Equipment)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //handle movement when user touch began
    func playerHandler(position: CGPoint) {
        
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


