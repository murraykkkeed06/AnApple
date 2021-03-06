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
    var showButton: MSButtonNode!
    
    var ability: Abiltiy!
    
    var equipButton: MSButtonNode!
    //detail display node
    var detailDisplay: SKSpriteNode!
    
    private var _isWeared: Bool!
    var isWeared: Bool{
        set{
            _isWeared = newValue
            switch newValue {
            case true:
                //move item in storage list
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
    
    
    init(texture: SKTexture, type: EquipmentType, ability: Abiltiy, equipmentBag: EquipmentBag, showButton: MSButtonNode) {
        super.init(texture: texture, color: .clear, size: CGSize(width: 40, height: 40))
        self.type = type
        self.homeScene = scene
        self.equipmentBag = equipmentBag
        self.storageBag = (showButton.childNode(withName: "storageBag") as! StorageBag)
        self.showButton = showButton
        //self.isWeared = false
        self.zPosition = 5
        self.ability = ability
        self.isUserInteractionEnabled = true
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = 128
        self.physicsBody?.collisionBitMask = 16
        self.physicsBody?.contactTestBitMask = 1
        
        
        
       detailDisplay = (showButton.childNode(withName: "//detailDisplay") as! SKSpriteNode)
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
        //detail will hide when storagebag is hide
        //let showButton = (self.parent!.parent! as! MSButtonNode)
        if showButton.buttonState == .hide {
            return
        }
        
        detailDisplay.isHidden = false
        let attackNumber = (detailDisplay.childNode(withName: "//attackNumber") as! SKLabelNode)
        let defenseNumber = (detailDisplay.childNode(withName: "//defenseNumber") as! SKLabelNode)
        let healthNumber = (detailDisplay.childNode(withName: "//healthNumber") as! SKLabelNode)
        
        self.equipButton = (detailDisplay.childNode(withName: "//equipButton") as! MSButtonNode)
        
        if self.isWeared{self.equipButton.isHidden=true}
        else {self.equipButton.isHidden=false}
        
        
        equipButton.selectedHandler = {
            
            self.isWeared = true
            if self.storageBag.storageList.count == 0{self.detailDisplay.isHidden = true}
            self.detailDisplay.isHidden = true
        }
        
        attackNumber.text = "\(self.ability.attackNumber!)"
        defenseNumber.text = "\(self.ability.defenseNumber!)"
        healthNumber.text = "\(self.ability.healthNumber!)"
    }
}
