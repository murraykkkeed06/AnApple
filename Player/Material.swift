//
//  Material.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class Material: SKSpriteNode {
    
    var materialBag: MaterialBag!
    
    var homeScene: SKScene!
    
    var ability: Abiltiy!
    
    init(texture: SKTexture, scene: SKScene) {
        super.init(texture: texture, color: .clear, size: CGSize(width: 40, height: 40))
        self.zPosition = 4
        self.homeScene = scene
        self.materialBag = (self.homeScene.childNode(withName: "materialBag") as! MaterialBag)
        self.materialBag.addMaterial(material: self)
        //self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self)
//        
//        self.position = location
//    }
    
}
