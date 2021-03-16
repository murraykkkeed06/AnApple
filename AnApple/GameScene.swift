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
    var timer: Timer?
    
    
    override func didMove(to view: SKView) {
        player = Player()
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //set player position when touch
        playerHandler(position: location)
        
    }
    
    func playerHandler(position: CGPoint) {
        
        //get another touch when player is moving
        if(player.isMoving){timer?.invalidate()}
        //moving left
        if(position.x < player.position.x){
            player.isMoving = true
            player.playerState = .goingLeft
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,selector: #selector(playerGoingLeft), userInfo: position, repeats: true)
        }
        //moviing right
        if(position.x>player.position.x){
            player.isMoving = true
            player.playerState = .goingRight
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,selector: #selector(playerGoingRight), userInfo: position, repeats: true)
        }
       
        
    }
    @objc func playerGoingLeft(timer: Timer) {
        let position = timer.userInfo as! CGPoint
        if(player.isMoving){
        player.position.x -= player.playerMoveDistance
            if (player.position.x <= position.x) {
                player.isMoving = false
                player.playerState = .idle
                timer.invalidate()
            }
        }
    }
    
    @objc func playerGoingRight(timer: Timer) {
        let position = timer.userInfo as! CGPoint
        if(player.isMoving){
        player.position.x += player.playerMoveDistance
            if (player.position.x >= position.x) {
                player.isMoving = false
                player.playerState = .idle
                timer.invalidate()
            }
        }
    }
    
    
}



