//
//  PlantCard.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class PlantCard: SKSpriteNode {
    
    var homeScene: SKScene!
    var plantCardBag: PlantCardBag!
    
    init(texture: SKTexture, scene: SKScene) {
        super.init(texture: texture, color: .clear, size: CGSize(width: 80, height: 80))
        self.homeScene = scene
        self.zPosition = 4
        self.plantCardBag = (self.homeScene.childNode(withName: "plantCardBag") as! PlantCardBag)
        self.plantCardBag.addPlantCard(plantCard: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

