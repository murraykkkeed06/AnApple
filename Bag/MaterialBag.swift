//
//  WearedBag.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class MaterialBag: SKSpriteNode {
    
    var materialList = [Material]()
    
    let materialMax = 7

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //self.isUserInteractionEnabled = true
    }
    
    func addMaterial(material: Material) {
        //if already exist
        for i in 0..<materialList.count{
            if materialList[i].name == material.name{
                 return
            }
        }
        //check full
        if materialList.count == materialMax {return}
        //add storage
        materialList.append(material)
        addChild(material)
        //render the bag
        renderMaterial()
    }
    
    
    func removeStorage(name: String){
        //check if empty
        if materialList.count == 0 {
            return
        }
        //remove
//        for i in 0..<storageList.count{
//            if storageList[i].name == name{
//                storageList.remove(at: i)
//            }
//        }
        materialList = materialList.filter({$0.name! != name})
        
        //render the bag
        renderMaterial()
    }
    
    func renderMaterial() {
        
        for i in 0..<materialList.count{
            //storageList.sort(by: {$0.name! < $1.name!})
            materialList[i].position = CGPoint(x: 50 + 50*i, y: 0 )
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        
        //print("\(nodeAtPoint.name)")
    }
    
    
    
    
}
