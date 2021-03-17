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
    
    var movingNode: SKSpriteNode!
    
    //access bag
    var equipmentBag: EquipmentBag!
    var storageBag: StorageBag!
    
    var ability: Abiltiy!
    
    //detail display node
    var detailDisplay: SKSpriteNode!
    
    private var _isWeared: Bool!
    var isWeared: Bool{
        set{
            _isWeared = newValue
            switch newValue {
            case true:
                //move iten in storage list
                storageBag.removeStorage(name: self.name!)
                //move parent to equipment bag
                equipmentBag.setupEquipment(equipment: self)
                
            case false:
                
                //add parent to storage bag
                storageBag.addStorage(storage: self)
                
            }
        }
        get{return _isWeared}
    }
    
    
    init(texture: SKTexture, type: EquipmentType, scene: SKScene, ability: Abiltiy) {
        super.init(texture: texture, color: .clear, size: CGSize(width: 40, height: 40))
        self.type = type
        self.homeScene = scene
        self.equipmentBag = (scene.childNode(withName: "equipmentBag") as! EquipmentBag)
        self.storageBag = (scene.childNode(withName: "//storageBag") as! StorageBag)
        self.isWeared = false
        self.zPosition = 5
        self.ability = ability
        self.isUserInteractionEnabled = true
        
       detailDisplay = (self.homeScene.childNode(withName: "//detailDisplay") as! SKSpriteNode)
        detailDisplay.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        setupDetailDisplay()
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //self.isWeared = true
        
    }
    
    func setupDetailDisplay()  {
        
        detailDisplay.isHidden = false
        let attackNumber = (detailDisplay.childNode(withName: "//attackNumber") as! SKLabelNode)
        let defenseNumber = (detailDisplay.childNode(withName: "//defenseNumber") as! SKLabelNode)
        let healthNumber = (detailDisplay.childNode(withName: "//healthNumber") as! SKLabelNode)
        
        let equipButton = (detailDisplay.childNode(withName: "//equipButton") as! MSButtonNode)
        
        equipButton.selectedHandler = {
            self.isWeared = true
            if self.storageBag.storageList.count == 0{self.detailDisplay.isHidden = true}
        }
        
        attackNumber.text = "\(self.ability.attackNumber!)"
        defenseNumber.text = "\(self.ability.defenseNumber!)"
        healthNumber.text = "\(self.ability.healthNumber!)"
    }
}
