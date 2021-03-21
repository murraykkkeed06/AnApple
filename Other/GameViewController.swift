//
//  GameViewController.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.player =  Player(scene: scene)
                scene.materialBag = (scene.childNode(withName: "materialBag") as! MaterialBag)
                scene.equipmentBag = (scene.childNode(withName: "equipmentBag") as! EquipmentBag)
                scene.showButton = (scene.childNode(withName: "showButton") as! MSButtonNode)
                scene.plantCardBag = (scene.childNode(withName: "plantCardBag") as! PlantCardBag)
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
