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
    var musica : SKSpriteNode!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var playMusic = true
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        let scaleRatio = self.frame.width / 667

        start = SKSpriteNode(imageNamed: "start")
        start.name = "Game Button"
        start.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 60)
        start.setScale(0.1 * scaleRatio)
        addChild(start)
        
        title = SKSpriteNode(imageNamed: "title")
        title.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 80)
        
        title.setScale(0.3 * scaleRatio)
        
        addChild(title)
        
        highScoreLabel = SKLabelNode(fontNamed: "VCR OSD Mono")
        let superScore = bestScore.integerForKey("bestScore")
        highScoreLabel.text = "High Score \(superScore)"
        highScoreLabel.horizontalAlignmentMode = .Center
        highScoreLabel.fontSize = 40
        highScoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 5)
        addChild(highScoreLabel)
        
        //Boton de musica
        
        
      
        
        print("------------------------------------------------")
        print(defaults.boolForKey("Musica"))
        
        if defaults.boolForKey("Musica") {
            musica = SKSpriteNode(imageNamed: "noMusic")
            musica.name = "Music"
            musica.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2 - 130)
            musica.setScale(0.15 * scaleRatio)
            addChild(musica)
            
        }
        
        else {
            
            musica = SKSpriteNode(imageNamed: "music")
            musica.name = "Music"
            musica.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2 - 130)
            musica.setScale(0.15 * scaleRatio)
            addChild(musica)
        }
        
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
            else if touchedNode.name == "Music" {
                
                if defaults.boolForKey("Musica") {
                    musica.texture = SKTexture(imageNamed: "music")
                    defaults.setBool(false, forKey: "Musica")
                    print("MUSIC")
                }
                
                else  {
                    musica.texture = SKTexture(imageNamed: "noMusic")
                    defaults.setBool(true, forKey: "Musica")
                    print("NOMUSIC")
                }
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
