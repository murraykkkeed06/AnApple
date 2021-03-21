//
//  FightScreen.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/19.
//

import Foundation
import SpriteKit

class FightScreen: SKSpriteNode {
    
    var playerTimer: Timer!
    var monsterTimer: Timer!
    
    var player: Player!
    var monster: Monster!
    
    //sprite show on fight screen
    var playerNode: SKSpriteNode!
    var monsterNode: SKSpriteNode!

    var monsterList: [Monster]!
    
    var gameOver : ()->Void = { print("game over not implemented!") }
    
    func handleFight(nodeA: SKNode, nodeB: SKNode, monsterList: [Monster]) {
        
        if (nodeA.name == "furry" && nodeB.name == "player"){
            player = nodeB as? Player
            monster = nodeA as? Monster
        }else if nodeA.name == "player" && nodeB.name == "furry" {
            player = nodeA as? Player
            monster = nodeB as? Monster
        }else { return }
        
        self.monsterList = monsterList
        
        playerNode = SKSpriteNode(texture: SKTexture(imageNamed: "nakedAnt_2"), color: .clear, size: CGSize(width: 50, height: 50))
        
        monsterNode = SKSpriteNode(texture: SKTexture(imageNamed: "furry"), color: .clear, size: CGSize(width: 50, height: 50))
        
        let playerPosition = self.childNode(withName: "playerFightPosition")!.position
        let enemyPosition = self.childNode(withName: "enemyFightPosition")!.position
        
        addChild(playerNode)
        playerNode.zPosition = 6
        playerNode.position = playerPosition
        addChild(monsterNode)
        monsterNode.zPosition = 6
        monsterNode.position = enemyPosition
        
        self.isUserInteractionEnabled = true
        let action = SKAction.move(to: CGPoint(x: 350, y: 192), duration: 1)
        action.timingMode = .easeInEaseOut
        self.run(action)
        
        
        //start fighting
        playerTimer = Timer.scheduledTimer(timeInterval: player.attackInterval, target: self,selector: #selector(fightRight), userInfo: nil, repeats: true)
        
        monsterTimer = Timer.scheduledTimer(timeInterval: monster.attackInterval, target: self,selector: #selector(fightLeft), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func fightRight(){
        playerNode.run(SKAction(named: "fightRight")!)
       // monster.ability.healthNumber += monster.ability.defenseNumber
        monster.ability.healthNumber -= player.ability.attackNumber
        if monster.ability.healthNumber <= 0 {
            monster.isAlived = false
            monsterTimer.invalidate()
            playerTimer.invalidate()
            monster.removeFromParent()
            //remove from list
            for i in 0..<self.monsterList.count{
                if monsterList[i].gridXY.x == monster.gridXY.x && monsterList[i].gridXY.y == monster.gridXY.y{
                    monsterList.remove(at: i)
                    break
                }
            }
            
            playerNode.removeFromParent()
            monsterNode.removeFromParent()
            self.run(SKAction.move(to: CGPoint(x: 999, y: 999), duration: 1))
        }
    }
    
    @objc func fightLeft(){
        monsterNode.run(SKAction(named: "fightLeft")!)
       // player.ability.healthNumber += player.ability.defenseNumber
        player.ability.healthNumber -= monster.ability.attackNumber
        if player.ability.healthNumber <= 0 {
            playerTimer.invalidate()
            monsterTimer.invalidate()
            self.gameOver()
        }
       
    }
    
       
    
    
    
    
}



