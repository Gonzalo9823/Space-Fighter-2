//
//  GameScene.swift
//  NoName
//
//  Created by Gonzalo Caballero on 7/6/16.
//  Copyright (c) 2016 Gonzalo Caballero. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

struct Fisica {
    static let none : UInt32 = 0                //00000000
    static let player : UInt32 = 0b1            //00000001
    static let object : UInt32 = 0b10           //00000011
    static let bullets : UInt32 = 0b100         //00000111
    static let objectPowerUp : UInt32 = 0b1000  //00001111
    
}

let bestScore = NSUserDefaults.standardUserDefaults()

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController: GameViewController!
    
    var hero : SKSpriteNode!
    var controllerAfuera : SKSpriteNode!
    var controllerAdentro : SKSpriteNode!
    var fireButtonAfuera : SKSpriteNode!
    var fireButtonAdentro : SKSpriteNode!
    var disparo : SKSpriteNode!
    var meteor : SKSpriteNode!
    var powerUpMeteor : SKSpriteNode!
    var timerFirstLevel = NSTimer()
    var timerSecondLevel = NSTimer()
    var timer2 = NSTimer()
    var selectedNodes = [UITouch:SKSpriteNode]()
    var meteorAnimation = Array<SKTexture>()
    var powerUpMeteorAnimation = Array<SKTexture>()
    var numberOfHits = 0
    var gameOver: SKLabelNode!
    var restartButton: SKSpriteNode!
    var timesFire: SKSpriteNode!
    var fireNumber = 0
    var score = 0
    var scoreLabel : SKLabelNode!
    var canFire = true
    var alive = true
    var speedOfMeteor : NSTimeInterval = 5
    var seconds = 1.8
    var gameMusic: AVAudioPlayer!
    var menuButton: SKSpriteNode!
    let halfPie =  CGFloat(M_PI / 2)
    
    
    override func didMoveToView(view: SKView) {
        
        let scaleRatio = self.frame.width / 667
        // SOUNDS
        
        let path = NSBundle.mainBundle().pathForResource("backgroundSound.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            gameMusic = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
        
        //Animacion de meteoro
        for i in 1...30 {
            meteorAnimation.append(SKTexture(imageNamed: "rocks-\(i)"))
        }
        
        //Animacion de meteoro 2
        for i in 1...30 {
            powerUpMeteorAnimation.append(SKTexture(imageNamed: "small-rocks-\(i)"))
        }
        
        //Barra de disparo
        timesFire = SKSpriteNode(imageNamed: "0fires")
        timesFire.position = CGPoint(x: self.frame.width / 2 - 150, y: self.frame.height / 2 + 150)
        timesFire.setScale(0.1 * scaleRatio)
        addChild(timesFire)
        
        //Para la Fisica
        physicsWorld.contactDelegate = self
        
        //Timers
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(0.3, target:self, selector: Selector("bajarFireNumber"), userInfo: nil, repeats: true)
        
        //Score
        
        scoreLabel = SKLabelNode(fontNamed: "VCR OSD Mono")
        scoreLabel.text = "Score \(score)"
        scoreLabel.horizontalAlignmentMode = .Center
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: self.frame.width / 2 + 150, y: self.frame.height / 2 + 135)
        addChild(scoreLabel)
        
        
        //Hero
        hero = SKSpriteNode(imageNamed: "hero")
        hero.setScale(0.03)
        hero.name = "hero"
        hero.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hero.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        addChild(hero)
        
        hero.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 30, height: 30))
        hero.physicsBody?.dynamic = true
        hero.physicsBody?.affectedByGravity = false
        
        hero.physicsBody?.categoryBitMask    = Fisica.player
        hero.physicsBody?.contactTestBitMask = Fisica.object
        hero.physicsBody?.collisionBitMask   = Fisica.none
        
        //Controllers
        
        controllerAfuera = SKSpriteNode(color: UIColor.brownColor() , size: CGSize(width: 75, height: 75))
        controllerAfuera.position = CGPoint(x: self.frame.width / 2 + 200, y: self.frame.height / 2 - 100)
        addChild(controllerAfuera)
        
        controllerAdentro = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 55, height: 55))
        controllerAdentro.position = CGPoint(x: self.frame.width / 2 + 200, y: self.frame.height / 2 - 100)
        controllerAdentro.name = "adentro"
        addChild(controllerAdentro)
        
        //Fire
        
        fireButtonAfuera = SKSpriteNode(color: UIColor.brownColor() , size: CGSize(width: 75, height: 75))
        fireButtonAfuera.position = CGPoint(x: self.frame.width / 2 - 200, y: self.frame.height / 2 - 100)
        addChild(fireButtonAfuera)
        
        fireButtonAdentro = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 55, height: 55))
        fireButtonAdentro.position = CGPoint(x: self.frame.width / 2 - 200, y: self.frame.height / 2 - 100)
        fireButtonAdentro.name = "fire"
        addChild(fireButtonAdentro)
        
        // TIMER
        
        let crearObstaculo = SKAction.runBlock {
            self.createMeteor()
            self.randomPowerUp()
        }
        
        let moveFaster = SKAction.runBlock {
            self.moverMasRapido()
        }
        
        let waitToMoveFaster = SKAction.waitForDuration(6)
        
        runAction(SKAction.sequence([waitToMoveFaster, moveFaster]))
        
        let wait = SKAction.waitForDuration(1)
        let sq = SKAction.sequence([crearObstaculo, wait])
        let repeatForever = SKAction.repeatActionForever(sq)
        runAction(repeatForever)
        
    }
    
    var tiempoEntreCreacion : NSTimeInterval = 1.3
    
    
    func moverMasRapido() {
        
        print("First time : \(tiempoEntreCreacion)")
        removeActionForKey("meteors")
        tiempoEntreCreacion *= 0.8
        print("Second time : \(tiempoEntreCreacion)")
        
        
        let meteorWait = SKAction.waitForDuration(tiempoEntreCreacion)
        let crear = SKAction.runBlock {
            self.createMeteor()
        }
        let meteorSq = SKAction.sequence([crear, meteorWait])
        let repetir = SKAction.repeatActionForever(meteorSq)
        runAction(repetir, withKey: "meteors")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if let node = self.nodeAtPoint(location) as? SKSpriteNode {
                // Assumes sprites are named "sprite"
                if (node.name == "adentro") {
                    selectedNodes[touch] = node
                }
                else if (node.name == "fire") {
                    
                    fireButtonAfuera.alpha = 0.5
                    
                    fireBullet()
                    
                    
                }
                else if (node.name == "restart") {
                    
                    restartButton.alpha = 0.4
                    
                    let transition = SKTransition.fadeWithDuration(1)
                    
                    let nextScene = GameScene(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene, transition: transition)
                    nextScene.viewController = viewController
                }
                else if (node.name == "menu") {
                    let transition = SKTransition.fadeWithDuration(1)
                    
                    let nextScene = MenuScene(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene, transition: transition)
                    nextScene.viewController = viewController
                }
                
            }
        }
    }
    
    
    
    var physicsObjectsToRemove = [SKNode]()
    let explosion = SKAction.playSoundFileNamed("explsoion", waitForCompletion: false)
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == Fisica.bullets | Fisica.object {
            
            if contact.bodyA.node!.name == "meteor" {
                
                physicsObjectsToRemove.append(contact.bodyA.node!)
                physicsObjectsToRemove.append(disparo)
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyA.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                self.runAction(explosion)
                
                if alive {
                    score += 1
                }
            }
                
            else if contact.bodyB.node!.name == "meteor" {
                physicsObjectsToRemove.append(contact.bodyB.node!)
                disparo.removeFromParent()
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyB.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                self.runAction(explosion)
                
                if alive {
                    score += 1
                }
            }
        }
        
        if collision == Fisica.bullets | Fisica.objectPowerUp {
            if contact.bodyA.node!.name == "powerUpMeteor" {
                
                physicsObjectsToRemove.append(contact.bodyA.node!)
                physicsObjectsToRemove.append(disparo)
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyA.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                
                let sound = SKAction.playSoundFileNamed("powerUp", waitForCompletion: false)
                self.runAction(sound)
                
                if alive {
                    score += 1
                }
                
                numberOfHits = 0
                objectAndPlayerCollides()
            }
                
            else if contact.bodyB.node!.name == "powerUpMeteor" {
                
                physicsObjectsToRemove.append(contact.bodyB.node!)
                physicsObjectsToRemove.append(disparo)
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyB.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                
                let sound = SKAction.playSoundFileNamed("powerUp", waitForCompletion: false)
                self.runAction(sound)
                
                
                if alive {
                    score += 1
                }
                
                numberOfHits = 0
                objectAndPlayerCollides()
            }
        }
        
        if collision == Fisica.player | Fisica.object {
            
            print("Se tocan")
            
            if contact.bodyA.node!.name == "hero" {
                
                numberOfHits += 1
                
                physicsObjectsToRemove.append(contact.bodyB.node!)
                
                let fire = SKEmitterNode(fileNamed: "Fire")!
                fire.position = contact.bodyA.node!.position
                fire.numParticlesToEmit = 50
                addChild(fire)
                if alive {
                    self.runAction(explosion)
                }
                
                objectAndPlayerCollides()
                
            }
        }
        else if contact.bodyB.node!.name == "hero"  {
            
            numberOfHits += 1
            
            physicsObjectsToRemove.append(contact.bodyA.node!)
            
            let fire = SKEmitterNode(fileNamed: "Fire")!
            fire.position = contact.bodyB.node!.position
            fire.numParticlesToEmit = 50
            addChild(fire)
            
            if alive {
                self.runAction(explosion)
            }
            
            objectAndPlayerCollides()
        }
        
        if collision == Fisica.player | Fisica.objectPowerUp {
            
            if contact.bodyA.node!.name == "hero" {
                
                
                physicsObjectsToRemove.append(contact.bodyB.node!)
                
                let fire = SKEmitterNode(fileNamed: "Fire")!
                fire.position = contact.bodyA.node!.position
                fire.numParticlesToEmit = 50
                addChild(fire)
                
                if alive {
                    self.runAction(explosion)
                }
                
            }
        } else if contact.bodyB.node!.name == "hero"  {
            
            physicsObjectsToRemove.append(contact.bodyA.node!)
            
            let fire = SKEmitterNode(fileNamed: "Fire")!
            fire.position = contact.bodyB.node!.position
            fire.numParticlesToEmit = 50
            addChild(fire)
            
            if alive {
                self.runAction(explosion)
            }
        }
        
    }
    
    override func didSimulatePhysics() {
        for node in physicsObjectsToRemove {
            node.removeFromParent()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        
        scoreLabel.text = "Score \(score)"
        
        switch fireNumber {
        case 0:
            timesFire.texture = SKTexture(imageNamed: "0fires")
            canFire = true
        case 1:
            timesFire.texture = SKTexture(imageNamed: "1fire")
            canFire = true
        //Andrew has a lot of porn on his computer
        case 2:
            timesFire.texture = SKTexture(imageNamed: "2fire")
            canFire = true
        case 3:
            timesFire.texture = SKTexture(imageNamed: "3fire")
            canFire = false
        default:
            timesFire.texture = SKTexture(imageNamed: "3fire")
            canFire = false
        }
        
        hero.zRotation = getAngle() - halfPie
        
        let acutualBestScore = bestScore.integerForKey("bestScore")
        
        if score > acutualBestScore {
            bestScore.setInteger(score, forKey: "bestScore")
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            // Update the position of the sprites
            if let node = selectedNodes[touch] {
                node.position = location
                let touchedNode = nodeAtPoint(location)
                
                if touchedNode.name == "adentro" {
                    controllerAdentro.position = location
                }
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if selectedNodes[touch] != nil {
                controllerAdentro.position = CGPoint(x: self.frame.width / 2 + 200, y: self.frame.height / 2 - 100)
                selectedNodes[touch] = nil
                
            }
            
            fireButtonAfuera.alpha = 1
            
        }
    }
    
    
    func createMeteor() {
        
        let meteor = SKSpriteNode(texture: meteorAnimation[0])
        let animateAction = SKAction.animateWithTextures(self.meteorAnimation, timePerFrame: 0.10);
        let repeatAction = SKAction.repeatActionForever(animateAction)
        meteor.runAction(repeatAction)
        
        meteor.name = "meteor"
        meteor.position = getMeteorPosition()
        meteor.zPosition = 2
        
        
        meteor.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 30, height: 30))
        meteor.physicsBody?.dynamic = false
        meteor.physicsBody?.affectedByGravity = false
        
        meteor.physicsBody?.categoryBitMask    = Fisica.object
        meteor.physicsBody?.contactTestBitMask = Fisica.player | Fisica.bullets
        meteor.physicsBody?.collisionBitMask   = Fisica.none
        
        addChild(meteor)
        moveToCenter(meteor)
    }
    
    func createPowerUpMeteor() {
        
        let powerUpMeteor = SKSpriteNode(texture: powerUpMeteorAnimation[0])
        let animateAction = SKAction.animateWithTextures(self.powerUpMeteorAnimation, timePerFrame: 0.10);
        let repeatAction = SKAction.repeatActionForever(animateAction)
        powerUpMeteor.runAction(repeatAction)
        
        powerUpMeteor.name = "powerUpMeteor"
        powerUpMeteor.position = getMeteorPosition()
        powerUpMeteor.zPosition = 2
        
        
        powerUpMeteor.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 30, height: 30))
        powerUpMeteor.physicsBody?.dynamic = true
        powerUpMeteor.physicsBody?.affectedByGravity = false
        
        powerUpMeteor.physicsBody?.categoryBitMask    = Fisica.objectPowerUp
        powerUpMeteor.physicsBody?.contactTestBitMask = Fisica.player | Fisica.bullets
        powerUpMeteor.physicsBody?.collisionBitMask   = Fisica.none
        
        addChild(powerUpMeteor)
        moveToCenter(powerUpMeteor)
        
    }
    
    func moveToCenter(meteor: SKSpriteNode) {
        
        
        let location = CGPoint (x: self.frame.width / 2, y: self.frame.height / 2)
        let gotoXY = SKAction.moveTo(location, duration: speedOfMeteor)
        
        meteor.runAction(gotoXY)
        
        
    }
    
    func getMeteorPosition() -> CGPoint {
        
        let degrees = GKRandomSource.sharedRandom().nextIntWithUpperBound(361)
        let radiants = Double(degrees) * M_PI / 180
        
        let x = getX(CGFloat(radiants))
        let y = getY(CGFloat(radiants))
        
        return CGPoint(x: x, y: y)
    }
    
    
    func getAngle() -> CGFloat {
        
        let punto1 = CGVector(point: controllerAfuera.position)
        let punto2 = CGVector(point: controllerAdentro.position)
        let p = punto2 - punto1
        let angle = atan2(p.dy, p.dx)
        return angle
    }
    
    func getX(number : CGFloat) -> CGFloat {
        
        return cos(number) * self.frame.width * 2
    }
    
    func getY(number : CGFloat) -> CGFloat {
        
        return sin(number) * self.frame.width * 2
    }
    
    
    
    func fireBullet() {
        
        disparo = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 3, height: 9))
        disparo.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2)
        disparo.zRotation = getAngle() + halfPie
        
        
        //        let moverX = SKAction.moveToX(getX(getAngle()), duration: 3)
        //        let moverY = SKAction.moveToY(getY(getAngle()), duration: 3)
        
        let x = getX(getAngle())
        let y = getY(getAngle())
        
        
        
        let mover = SKAction.moveTo(CGPoint(x: x, y: y), duration: 3)
        // SKAction.moveBy(<#T##delta: CGVector##CGVector#>, duration: <#T##NSTimeInterval#>)
        /// CGVector(dx: <#T##CGFloat#>, dy: <#T##CGFloat#>)
        
        
        disparo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 3, height: 9))
        disparo.physicsBody?.dynamic = true
        disparo.physicsBody?.affectedByGravity = false
        
        disparo.physicsBody?.categoryBitMask    = Fisica.bullets
        disparo.physicsBody?.contactTestBitMask = Fisica.object
        disparo.physicsBody?.collisionBitMask   = Fisica.none
        
        //        disparo.runAction(moverX)
        //        disparo.runAction(moverY)
        disparo.runAction(mover)
        
        let fireSFX = SKAction.playSoundFileNamed("fireSound", waitForCompletion: false)
        
        
        if fireNumber < 4 {
            fireNumber += 1
        }
        
        if canFire == true {
            
            addChild(disparo)
            self.runAction(fireSFX)
        }
        
    }
    
    func lost() {
        
        removeAllActions()
        alive = false
        
        gameOver = SKLabelNode(fontNamed: "VCR OSD Mono")
        gameOver.text = "Game Over!"
        gameOver.horizontalAlignmentMode = .Center
        gameOver.fontSize = 50
        gameOver.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 50)
        addChild(gameOver)
        
        restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.name = "restart"
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 60)
        restartButton.setScale(0.08)
        addChild(restartButton)
        
        menuButton = SKSpriteNode(imageNamed: "menu")
        menuButton.name = "menu"
        menuButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 120)
        menuButton.setScale(0.08)
        addChild(menuButton)
        
       
        gameMusic.stop()
        loadAd()
        
    }
    
    func loadAd() {
        let vc = viewController.storyboard!.instantiateViewControllerWithIdentifier("Ad")
        viewController.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func bajarFireNumber() {
        if fireNumber >= 1 {
            fireNumber -= 1
        }
    }
    
    func randomPowerUp() {
        let randomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(10)
        if randomNumber == 8 {
            createPowerUpMeteor()
        }
    }
    
    func objectAndPlayerCollides() {
        
        switch numberOfHits {
        case 0:
            hero.texture = SKTexture(imageNamed: "hero")
        case 1:
            hero.texture = SKTexture(imageNamed: "heroOneHit")
        case 2:
            hero.texture = SKTexture(imageNamed: "heroTwoHits")
        case 3:
            hero.texture = SKTexture(imageNamed: "heroThreeHits")
        case 4:
            hero.texture = SKTexture(imageNamed: "heroDead")
            lost()
        default:
            print("Ya perdiste")
        }
    }
}

