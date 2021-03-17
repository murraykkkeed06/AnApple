//
//  Material.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class Material: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
