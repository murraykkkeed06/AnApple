//
//  WearedBag.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class StorageBag: SKSpriteNode {
    
    var storageList = [Equipment]()
    
    let storageCol = 3
    let storageRow = 5

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.isUserInteractionEnabled = true
    }
    
    func addStorage(storage: Equipment) {
        //if already exist
        for i in 0..<storageList.count{
            if storageList[i].name == storage.name{
                 return
            }
        }
        //check full
        if storageList.count == storageRow * storageCol {return}
        //add storage
        storageList.append(storage)
        addChild(storage)
        //render the bag
        renderStorage()
    }
    
    
    func removeStorage(name: String){
        //check if empty
        if storageList.count == 0 {
            return
        }
        //remove
//        for i in 0..<storageList.count{
//            if storageList[i].name == name{
//                storageList.remove(at: i)
//            }
//        }
        storageList = storageList.filter({$0.name! != name})
        
        //render the bag
        renderStorage()
    }
    
    func renderStorage() {
        var x = 0
        var y = 0
        for i in 0..<storageList.count{
            //storageList.sort(by: {$0.name! < $1.name!})
            storageList[i].position = CGPoint(x: 30 + 60*x, y: -30 - 60*y)
            x += 1
            if x == storageCol{
                x = 0
                y += 1
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        
        //print("\(nodeAtPoint.name)")
    }
    
    
}
