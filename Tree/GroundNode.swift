//
//  TreeTexture.swift
//  AntAndApple
//
//  Created by 劉孟學 on 2021/3/10.
//

import Foundation
import SpriteKit
//Gound Size: 45*60
enum GroundType: UInt32 {
    case dirt
    case rock
    case wood

    
    private static let _count: GroundType.RawValue = {
        // find the maximum enum value
        var maxValue: UInt32 = 0
        while let _ = GroundType(rawValue: maxValue) {
            maxValue += 1
        }
        return maxValue
    }()

    static func getRadom(dirt: CGFloat, rock: CGFloat, wood: CGFloat) -> GroundType {
        // pick and return a new value
        //let rand = arc4random_uniform(_count)
        var result: UInt32!
        
        if CGFloat.random(in: 0..<100) < dirt*100 {
            result = 0
        }
        else if CGFloat.random(in: 0..<100) < (rock/(1-dirt))*100 {
            result = 1
        }
        else {
            result = 2
        }
        
        return GroundType(rawValue: result)!
    }
}


class GroundNode: SKSpriteNode {
    
    //var monsterList = [Monster]()
    
    
    var gridXY: GridXY!
    
    private var _groundType: GroundType!
    var groundType: GroundType{
        set{
            self._groundType = newValue
        }
        get{
            return self._groundType
        }
    }
    var left,right,top,bottom: GroundNode?
    
    private var _isDigged: Bool!
    var isDigged: Bool
    {
        set{
            _isDigged = newValue
            if (newValue==true){
                self.alpha=0
                self.isUserInteractionEnabled = false
                //self.physicsBody!.collisionBitMask = 0
                self.physicsBody = nil
                //self.removeFromParent()
                
            }
        }
        get{
            return _isDigged
        }
    }
    
    private var _neighborIsDigged: Bool!
    var neighborIsDigged: Bool
    {
        get{
            if let top = self.top{if top.isDigged{_neighborIsDigged = true}}
            if let bottom = self.bottom{if bottom.isDigged{_neighborIsDigged = true}}
            if let left = self.left{if left.isDigged{_neighborIsDigged = true}}
            if let right = self.right{if right.isDigged{_neighborIsDigged = true}}
            return _neighborIsDigged
        }
        set{
            _neighborIsDigged = newValue
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.zPosition = 2
        self.alpha = 0.8
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 45))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.pinned = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = 16
        self.physicsBody?.collisionBitMask = 1
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if neighborIsDigged && !isDigged && playerIsAround(){
            if self.groundType == .dirt {
            let digger = Digger()
            digger.position = CGPoint(x: 0, y: 30)
            digger.selectedHandler = {
                self.isDigged = true
            }
            addChild(digger)
            }
        }
    }
    
    func playerIsAround() -> Bool {
        
        var isAround = false
        
        if let top = self.top {
            if top.frame.contains(Player.playerPosition) {isAround = true}
        }
        if let bottom = self.bottom {
            if bottom.frame.contains(Player.playerPosition) {isAround = true}
        }
        if let left = self.left {
            if left.frame.contains(Player.playerPosition) {isAround = true}
        }
        if let right = self.right {
            if right.frame.contains(Player.playerPosition) {isAround = true}
        }
        
        
        
        return isAround
    }
    
    

}
