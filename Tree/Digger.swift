//
//  Digger.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/19.
//

import Foundation
import SpriteKit

class Digger: SKSpriteNode {
    
    var selectedHandler: () -> Void = { print("No button action set") }
    
    init() {
        let texture = SKTexture(imageNamed: "digger")
        super.init(texture: texture, color: .clear, size: CGSize(width: 100, height: 100))
        self.zPosition = 3
        self.run(SKAction(named: "digRotate")!)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        self.removeFromParent()
        self.isUserInteractionEnabled = false
    }
    
}
