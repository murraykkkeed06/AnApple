//
//  Equipment.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

enum EquipmentType: Int {
    case helmet
    case armor
    case pants
    case shoes
    case weapon
    
   
}

class Equipment: SKSpriteNode {
    
    var type: EquipmentType!
    
    var homeScene: SKScene!
    
    var equipmentBag: EquipmentBag!
    
    private var _isWeared: Bool!
    var isWeared: Bool{
        set{
            _isWeared = newValue
            switch newValue {
            case true:
                equipmentBag.setupEquipment(equipment: self)
                print("wearing")
            case false:
                print("not wear implementation")
            }
        }
        get{return _isWeared}
    }
    
    
    init(texture: SKTexture, type: EquipmentType, scene: SKScene) {
        super.init(texture: texture, color: .clear, size: CGSize(width: 40, height: 40))
        self.type = type
        self.homeScene = scene
        self.equipmentBag = (scene.childNode(withName: "equipmentBag") as! EquipmentBag)
        self.isWeared = false
        self.zPosition = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}