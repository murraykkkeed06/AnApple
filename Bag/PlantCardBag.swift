//
//  WearedBag.swift
//  AnApple
//
//  Created by 劉孟學 on 2021/3/16.
//

import Foundation
import SpriteKit

class PlantCardBag: SKSpriteNode {
    
    var plantCardList = [PlantCard]()
    
    let plantCardMax = 8

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //self.isUserInteractionEnabled = true
    }
    
    func addPlantCard(plantCard: PlantCard) {
        //if already exist
        for i in 0..<plantCardList.count{
            if plantCardList[i].name == plantCard.name{
                 return
            }
        }
        //check full
        if plantCardList.count == plantCardMax {return}
        //add storage
        plantCardList.append(plantCard)
        addChild(plantCard)
        //render the bag
        renderPlantCard()
    }
    
    
    func removePlantCard(name: String){
        //check if empty
        if plantCardList.count == 0 {
            return
        }
        //remove
        for i in 0..<plantCardList.count{
            if plantCardList[i].name == name{
                plantCardList.remove(at: i)
                break
            }
        }
        
//        plantCardList = plantCardList.filter({$0.name! != name})
        
        //render the bag
        renderPlantCard()
    }
    
    func renderPlantCard() {
        
        for i in 0..<plantCardList.count{
            //storageList.sort(by: {$0.name! < $1.name!})
            plantCardList[i].position = CGPoint(x: 50 + 50*i, y: 0 )
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        
        //print("\(nodeAtPoint.name)")
    }
    
    
    
    
}
