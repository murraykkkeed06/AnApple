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
    
    private var _helmet: Equipment!
    var helmet: Equipment{
        set{
            _helmet = newValue
            _helmet.position = helmetPosition
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
        }
        get{
            return _helmet
        }
    }
    private var _armor: Equipment!
    var armor: Equipment{
        set{
            _armor = newValue
            _armor.position = armorPosition
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
        //addChild(equipment)
        equipment.move(toParent: self)
        let type: EquipmentType = equipment.type
        switch type{
        case .helmet:
            helmet = equipment
            print("helmet")
        case .weapon:
            weapon = equipment
        case .armor:
            armor = equipment
        case .pants:
            pants = equipment
        case .shoes:
            shoes = equipment
            print("shoes")
        }
    }
    
}
