//
//  EquipmentList.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class PlantCardList {
    
    var componentList = [PlantCard]()
    
    func addComponent(component: PlantCard){
        componentList.append(component)
    }
    
    func removeComponent(name: String){
        //check if empty
        if componentList.count == 0 {
            return
        }
        //sort first then remove
        componentList.sort(by: {$0.name! < $1.name!})
        for i in 0..<componentList.count{
            if componentList[i].name == name{
                componentList.remove(at: i)
                break
            }
        }
    }
    
}

