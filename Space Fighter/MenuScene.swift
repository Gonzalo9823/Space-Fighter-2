//
//  MenuScene.swift
//  NoName
//
//  Created by Gonzalo Caballero on 7/7/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


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
    var ayuda : SKSpriteNode!
    var imagenAyuda : SKSpriteNode!
    var settings : SKSpriteNode!
    var mundial : SKSpriteNode!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var playMusic = true
    
    var preferredLanguages : NSLocale!
    
    var espanol = false
    
    enum Dificulty: String{
        case Easy = "Easy"
        case Medium = "Medium"
        case Hard = "Hard"
    }
    
    var currentDificulty: Dificulty = .Medium
    
    override func didMoveToView(view: SKView) {
        
        if let estado = defaults.objectForKey("Dificultad") as? String {
            currentDificulty = Dificulty(rawValue: estado)!
        }
        
        let pre = NSLocale.preferredLanguages()[0]
        
        if (pre.rangeOfString("es") != nil) {
            espanol = true
        }
        
        let scaleRatio = self.frame.width / 667
        
        if espanol {
            start = SKSpriteNode(imageNamed: "jugar")
        }
        else {
            start = SKSpriteNode(imageNamed: "start")
        }
        
        //Start button
        start.name = "Game Button"
        start.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 60)
        start.setScale(0.1 * scaleRatio)
        addChild(start)
        
        //Title
        title = SKSpriteNode(imageNamed: "title")
        title.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 80)
        title.setScale(0.3 * scaleRatio)
        addChild(title)
        
        //High Score Label
        highScoreLabel = SKLabelNode(fontNamed: "VCR OSD Mono")
        
        let superScoreEasy = defaults.integerForKey("bestScoreEasy")
        let superScore = defaults.integerForKey("bestScore")
        let superScoreHard = defaults.integerForKey("bestScoreHard")
        
        if espanol {
            switch currentDificulty  {
            case .Easy:
                highScoreLabel.text = "Mejor puntaje en facíl \(superScoreEasy)"
            case .Medium:
                highScoreLabel.text = "Mejor puntaje en intermedio \(superScore)"
            case .Hard:
                highScoreLabel.text = "Mejor puntaje en difícil \(superScoreHard)"
            }
        }
        else {
            switch currentDificulty {
            case .Easy:
                highScoreLabel.text = "High score on easy \(superScoreEasy)"
            case .Medium:
                highScoreLabel.text = "High score on medium \(superScore)"
            case .Hard:
                highScoreLabel.text = "High score on hard \(superScoreHard)"
            }
        }
        highScoreLabel.horizontalAlignmentMode = .Center
        if espanol {
            highScoreLabel.fontSize = 35
        } else {
            highScoreLabel.fontSize = 40
        }
        highScoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 5)
        addChild(highScoreLabel)
        
        //Ayuda
        
        ayuda = SKSpriteNode(imageNamed: "ayuda")
        ayuda.name = "Ayuda"
        ayuda.position = CGPoint(x: self.frame.width / 2 + 60 , y: self.frame.height / 2 - 130)
        ayuda.setScale(0.2 * scaleRatio)
        addChild(ayuda)
        
        if espanol {
            imagenAyuda = SKSpriteNode(imageNamed: "ImagenAyudaEspanol")
            imagenAyuda.name = "Imagen Ayuda"
            imagenAyuda.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            imagenAyuda.zPosition = 4
            //imagenAyuda.setScale(0.55 * scaleRatio)
            imagenAyuda.size = view.frame.size
            imagenAyuda.alpha = 0
            addChild(imagenAyuda)
        }
            
        else {
            imagenAyuda = SKSpriteNode(imageNamed: "imagenAyuda")
            imagenAyuda.name = "Imagen Ayuda"
            imagenAyuda.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            imagenAyuda.zPosition = 4
            //imagenAyuda.setScale(0.55 * scaleRatio)
            imagenAyuda.size = view.frame.size
            imagenAyuda.alpha = 0
            addChild(imagenAyuda)
        }
        
        //Settings
        
        settings = SKSpriteNode(imageNamed: "Settings")
        settings.name = "Settings"
        settings.position = CGPoint(x: self.frame.width / 2 - 60 , y: self.frame.height / 2 - 130)
        settings.setScale(0.1 * scaleRatio)
        addChild(settings)
        
        //Boton de HighScoreMundial
        mundial = SKSpriteNode(imageNamed: "World")
        mundial.name = "Mundial"
        mundial.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 130)
        mundial.setScale(0.2 * scaleRatio)
        addChild(mundial)
        
        
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
                
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                
                scene?.view?.presentScene(nextScene, transition: transition)
                nextScene.viewController = viewController
                
            }
                
            else if touchedNode.name == "Ayuda" {
                let mostrar = SKAction.fadeInWithDuration(0.4)
                imagenAyuda.runAction(mostrar)
            }
            else if touchedNode.name == "Imagen Ayuda" {
                let mostrar = SKAction.fadeOutWithDuration(0.4)
                imagenAyuda.runAction(mostrar)
            }
            else if touchedNode.name == "Settings" {
                
                settings.alpha = 0.4
                
                let transition = SKTransition.fadeWithDuration(0.5)
                
                let nextScene = Settings(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                
                scene?.view?.presentScene(nextScene, transition: transition)
                nextScene.viewController = viewController
                
                
            }
            else if touchedNode.name == "Mundial" {
                
                let vc = viewController.storyboard?.instantiateViewControllerWithIdentifier("mundialScore")
                viewController.presentViewController(vc!, animated: true, completion: nil)
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
