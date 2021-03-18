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

    static func getRadom() -> GroundType {
        // pick and return a new value
        let rand = arc4random_uniform(_count)
        return GroundType(rawValue: rand)!
    }
}


class GroundNode: SKSpriteNode {
    
    //var monsterList = [Monster]()
    
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
                self.alpha=0.5
                self.physicsBody = nil
                
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
    
    
   

    

}
