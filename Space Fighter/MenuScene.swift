//
//  MenuScene.swift
//  NoName
//
//  Created by Gonzalo Caballero on 7/7/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    var viewController: GameViewController!

    override init(size:CGSize){
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var start : SKSpriteNode!
    var title : SKSpriteNode!
    var highScoreLabel : SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        start = SKSpriteNode(imageNamed: "start")
        start.name = "Game Button"
        start.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 60)
        start.setScale(0.1)
        addChild(start)
        
        title = SKSpriteNode(imageNamed: "title")
        title.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 80)
        title.setScale(0.3)
        addChild(title)
        
        highScoreLabel = SKLabelNode(fontNamed: "VCR OSD Mono")
        let superScore = bestScore.integerForKey("bestScore")
        highScoreLabel.text = "High Score \(superScore)"
        highScoreLabel.horizontalAlignmentMode = .Center
        highScoreLabel.fontSize = 40
        highScoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 5)
        addChild(highScoreLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "Game Button" {
                
                start.alpha = 0.4
                
                let transition = SKTransition.fadeWithDuration(1)
                
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
                nextScene.viewController = viewController

            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        start.alpha = 1
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
