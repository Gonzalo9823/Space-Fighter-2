//
//  Settings.swift
//  Space Fighter
//
//  Created by Gonzalo Caballero on 8/1/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import SpriteKit
import Firebase
import FirebaseDatabase

class Settings: SKScene {
    
    override init(size:CGSize){
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewController: GameViewController!
    var backButton: SKSpriteNode!
    var musica : SKSpriteNode!
    
    var easy: SKSpriteNode!
    var medium: SKSpriteNode!
    var hard: SKSpriteNode!
    
    var preferredLanguages : NSLocale!
    var espanol = false
    
    enum Dificulty: String{
        case Easy = "Easy"
        case Medium = "Medium"
        case Hard = "Hard"
    }
    
    var currentDificulty: Dificulty = .Medium
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var playMusic = true
    
    var uploadBestScore: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        
        let pre = NSLocale.preferredLanguages()[0]
        
        if (pre.rangeOfString("es") != nil) {
            espanol = true
        }
        
        if let estado = defaults.objectForKey("Dificultad") as? String {
            currentDificulty = Dificulty(rawValue: estado)!
        }
        
        let scaleRatio = self.frame.width / 667
        
        //Subir mejor puntaje
        if espanol {
            uploadBestScore = SKSpriteNode(imageNamed: "subirMejorPuntaje")
        } else {
            uploadBestScore = SKSpriteNode(imageNamed: "uploadHighScore")
        }
        uploadBestScore.name = "Subir"
        uploadBestScore.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 60)
        uploadBestScore.setScale(0.1 * scaleRatio)
        addChild(uploadBestScore)
        
        
        if espanol {
            backButton = SKSpriteNode(imageNamed: "Atras")
            backButton.name = "Back"
            backButton.position = CGPoint(x: self.frame.width / 2 - 280, y: self.frame.height - 35)
            backButton.setScale(0.15 * scaleRatio)
            addChild(backButton)
        }
        else {
            backButton = SKSpriteNode(imageNamed: "Back")
            backButton.name = "Back"
            backButton.position = CGPoint(x: self.frame.width / 2 - 280, y: self.frame.height - 35)
            backButton.setScale(0.15 * scaleRatio)
            addChild(backButton)
        }
        
        if espanol {
            if currentDificulty == .Easy {
                
                easy = SKSpriteNode(imageNamed: "FacilApretado")
                easy.name = "Easy"
                easy.position = CGPoint(x: self.frame.width / 2 - 191.52, y: self.frame.height / 2 + 30)
                easy.setScale(0.08 * scaleRatio)
                addChild(easy)
                
            } else {
                easy = SKSpriteNode(imageNamed: "Facil")
                easy.name = "Easy"
                easy.position = CGPoint(x: self.frame.width / 2 - 191.52, y: self.frame.height / 2 + 30)
                easy.setScale(0.08 * scaleRatio)
                addChild(easy)
            }
            
            if currentDificulty == .Medium {
                medium = SKSpriteNode(imageNamed: "IntermedioApretado")
                medium.name = "Medium"
                medium.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 30)
                medium.setScale(0.08 * scaleRatio)
                medium.zPosition = 2
                addChild(medium)
            } else {
                medium = SKSpriteNode(imageNamed: "Intermedio")
                medium.name = "Medium"
                medium.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 30)
                medium.setScale(0.08 * scaleRatio)
                medium.zPosition = 2
                addChild(medium)
            }
            
            if currentDificulty == .Hard {
                hard = SKSpriteNode(imageNamed: "DificilApretado")
                hard.name = "Hard"
                hard.position = CGPoint(x: self.frame.width / 2 + 191.52, y: self.frame.height / 2 + 30)
                hard.setScale(0.08 * scaleRatio)
                addChild(hard)
            } else {
                hard = SKSpriteNode(imageNamed: "Dificil")
                hard.name = "Hard"
                hard.position = CGPoint(x: self.frame.width / 2 + 191.52, y: self.frame.height / 2 + 30)
                hard.setScale(0.08 * scaleRatio)
                addChild(hard)
            }
        }
            
        else if espanol == false {
            if currentDificulty == .Easy {
                
                easy = SKSpriteNode(imageNamed: "EasyPressed")
                easy.name = "Easy"
                easy.position = CGPoint(x: self.frame.width / 2 - 191.52, y: self.frame.height / 2 + 30)
                easy.setScale(0.08 * scaleRatio)
                addChild(easy)
                
            } else {
                easy = SKSpriteNode(imageNamed: "Easy")
                easy.name = "Easy"
                easy.position = CGPoint(x: self.frame.width / 2 - 191.52, y: self.frame.height / 2 + 30)
                easy.setScale(0.08 * scaleRatio)
                addChild(easy)
            }
            
            if currentDificulty == .Medium {
                medium = SKSpriteNode(imageNamed: "MediumPressed")
                medium.name = "Medium"
                medium.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 30)
                medium.setScale(0.08 * scaleRatio)
                medium.zPosition = 2
                addChild(medium)
            } else {
                medium = SKSpriteNode(imageNamed: "Medium")
                medium.name = "Medium"
                medium.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 30)
                medium.setScale(0.08 * scaleRatio)
                medium.zPosition = 2
                addChild(medium)
            }
            
            if currentDificulty == .Hard {
                hard = SKSpriteNode(imageNamed: "HardPressed")
                hard.name = "Hard"
                hard.position = CGPoint(x: self.frame.width / 2 + 191.52, y: self.frame.height / 2 + 30)
                hard.setScale(0.08 * scaleRatio)
                addChild(hard)
            } else {
                hard = SKSpriteNode(imageNamed: "Hard")
                hard.name = "Hard"
                hard.position = CGPoint(x: self.frame.width / 2 + 191.52, y: self.frame.height / 2 + 30)
                hard.setScale(0.08 * scaleRatio)
                addChild(hard)
            }
        }
        
        if defaults.boolForKey("Musica") {
            musica = SKSpriteNode(imageNamed: "noMusic")
            musica.name = "Music"
            musica.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 130)
            musica.setScale(0.2 * scaleRatio)
            addChild(musica)
            
        }
            
        else {
            
            musica = SKSpriteNode(imageNamed: "music")
            musica.name = "Music"
            musica.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 130)
            musica.setScale(0.2 * scaleRatio)
            addChild(musica)
            
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "Back" {
                backButton.alpha = 0.4
                let transition = SKTransition.fadeWithDuration(0.5)
                let nextScene = MenuScene(size: scene!.size)
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
                
            else if touchedNode.name == "Subir" {
                let vc = viewController.storyboard?.instantiateViewControllerWithIdentifier("upload")
                viewController.presentViewController(vc!, animated: true, completion: nil)
            }
            
            if espanol {
                if touchedNode.name == "Easy" {
                    easy.texture = SKTexture(imageNamed: "FacilApretado")
                    currentDificulty = .Easy
                    print("Easy Pressed")
                    defaults.setObject("Easy", forKey: "Dificultad")
                    
                    medium.texture = SKTexture(imageNamed: "Intermedio")
                    hard.texture = SKTexture(imageNamed: "Dificil")
                }
                    
                else if touchedNode.name == "Medium" {
                    medium.texture = SKTexture(imageNamed: "IntermedioApretado")
                    currentDificulty = .Medium
                    print("Medium Pressed")
                    defaults.setObject("Medium", forKey: "Dificultad")
                    
                    easy.texture = SKTexture(imageNamed: "Facil")
                    hard.texture = SKTexture(imageNamed: "Dificil")
                }
                    
                else if touchedNode.name == "Hard" {
                    hard.texture = SKTexture(imageNamed: "DificilApretado")
                    currentDificulty = .Hard
                    print("Hard Pressed")
                    defaults.setObject("Hard", forKey: "Dificultad")
                    
                    
                    easy.texture = SKTexture(imageNamed: "Facil")
                    medium.texture = SKTexture(imageNamed: "Intermedio")
                }
            }
                
            else if espanol == false {
                if touchedNode.name == "Easy" {
                    easy.texture = SKTexture(imageNamed: "EasyPressed")
                    currentDificulty = .Easy
                    print("Easy Pressed")
                    defaults.setObject("Easy", forKey: "Dificultad")
                    
                    medium.texture = SKTexture(imageNamed: "Medium")
                    hard.texture = SKTexture(imageNamed: "Hard")
                }
                    
                else if touchedNode.name == "Medium" {
                    medium.texture = SKTexture(imageNamed: "MediumPressed")
                    currentDificulty = .Medium
                    print("Medium Pressed")
                    defaults.setObject("Medium", forKey: "Dificultad")
                    
                    easy.texture = SKTexture(imageNamed: "Easy")
                    hard.texture = SKTexture(imageNamed: "Hard")
                }
                    
                else if touchedNode.name == "Hard" {
                    hard.texture = SKTexture(imageNamed: "HardPressed")
                    currentDificulty = .Hard
                    print("Hard Pressed")
                    defaults.setObject("Hard", forKey: "Dificultad")
                    
                    easy.texture = SKTexture(imageNamed: "Easy")
                    medium.texture = SKTexture(imageNamed: "Medium")
                }
            }
        }
        
    }
}