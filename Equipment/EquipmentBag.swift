//
//  EquipmentBat.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class EquipmentBag: SKSpriteNode {
    
    var helmetPosition: CGPoint!
    var weaponPosition: CGPoint!
    var armorPosition: CGPoint!
    var pantsPosition: CGPoint!
    var shoesPosition: CGPoint!
    
    var helmetIsSet = false
    var weaponIsSet = false
    var armorIsSet = false
    var pantsIsSet = false
    var shoesIsSet = false
    
    private var _helmet: Equipment!
    var helmet: Equipment{
        set{
            _helmet = newValue
            _helmet.position = helmetPosition
            helmetIsSet = true
        }
        get{
            return _helmet
        }
    }
    private var _weapon: Equipment!
    var weapon: Equipment{
        set{
            _weapon = newValue
            _weapon.position = weaponPosition
            weaponIsSet = true
        }
        get{
            return _weapon
        }
    }
    private var _armor: Equipment!
    var armor: Equipment{
        set{
            _armor = newValue
            _armor.position = armorPosition
            armorIsSet = true
        }
        get{
            return _armor
        }
    }
    private var _pants: Equipment!
    var pants: Equipment{
        set{
            _pants = newValue
            _pants.position = pantsPosition
            pantsIsSet = true
        }
        get{
            return _pants
        }
    }
    
    private var _shoes: Equipment!
    var shoes: Equipment{
        set{
            _shoes = newValue
            _shoes.position = shoesPosition
            shoesIsSet = true
        }
        get{
            return _shoes
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //get position
        helmetPosition = self.childNode(withName: "//helmet")?.position
        weaponPosition = self.childNode(withName: "//weapon")?.position
        armorPosition = self.childNode(withName: "//armor")?.position
        pantsPosition = self.childNode(withName: "//pants")?.position
        shoesPosition = self.childNode(withName: "//shoes")?.position
        
    }
    
    func setupEquipment(equipment: Equipment) {
        //check if is set yet
        
        //addChild(equipment)
        equipment.move(toParent: self)
        let type: EquipmentType = equipment.type
        switch type{
        case .helmet:
            if helmetIsSet{helmet.removeFromParent();helmet.isWeared=false}
            helmet = equipment
        case .weapon:
            if weaponIsSet{weapon.removeFromParent();weapon.isWeared=false}
            weapon = equipment
        case .armor:
            if armorIsSet{armor.removeFromParent();armor.isWeared=false}
            armor = equipment
        case .pants:
            if pantsIsSet{pants.removeFromParent();pants.isWeared=false}
            pants = equipment
        case .shoes:
            if shoesIsSet{shoes.removeFromParent();shoes.isWeared=false}
            shoes = equipment
            print("shoes")
        }
    }
    
}
