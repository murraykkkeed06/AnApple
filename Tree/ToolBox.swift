//
//  ToolBox.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/21.
//

import Foundation
import SpriteKit

class ToolBox: SKSpriteNode {
    
    var selectHandler : ()->Void = {print("not implemented!")}
    
    init(){
        let texture = SKTexture(imageNamed: "toolBox")
        super.init(texture: texture, color: .clear, size: CGSize(width: 80, height: 60))
        self.zPosition = 2
        self.anchorPoint = CGPoint(x: 0, y: 0 )
        self.name = "toolBox"
        self.isUserInteractionEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectHandler()
    }
}
