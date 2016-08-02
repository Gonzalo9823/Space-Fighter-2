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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: - Variables
    let defaults = NSUserDefaults.standardUserDefaults()
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
    var preferredLanguages : NSLocale!
    var espanol = false
    
    enum Dificulty: String{
        case Easy = "Easy"
        case Medium = "Medium"
        case Hard = "Hard"
    }
    
    var currentDificulty: Dificulty = .Medium
    
    
    //MARK: - GAME LIFE CYCLE
    override func didMoveToView(view: SKView) {
        // This way it knows at what size should show the nodes
        let scaleRatio = self.frame.width / 667
        let scaleRatioiPhone5 = self.frame.width / 568
        let scaleRatioiPhone4 = self.frame.width / 480
        
        //Gets the language of the device if it's spanish shows everything on spanish
        let pre = NSLocale.preferredLanguages()[0]
        if (pre.rangeOfString("es") != nil) {
            espanol = true
        }
        
        // Get's the saved value for the music
        let playMusic = defaults.boolForKey("Musica")
        
        // See if it should play the background music
        
        func playBackGroundMusic() {
            
            let path = NSBundle.mainBundle().pathForResource("backgroundSound.mp3", ofType:nil)!
            let url = NSURL(fileURLWithPath: path)
            do {
                let sound = try AVAudioPlayer(contentsOfURL: url)
                gameMusic = sound
                sound.play()
                
            } catch {
                // couldn't load file :(
            }
        }
        
        
        if playMusic == false {
           playBackGroundMusic()
        }
        
        //Gets the dificulty
        if let estado = defaults.objectForKey("Dificultad") as? String {
            currentDificulty = Dificulty(rawValue: estado)!
        }
        
        switch currentDificulty {
        case .Easy:
            speedOfMeteor = 6
        case .Medium:
            speedOfMeteor = 5
        case .Hard:
            speedOfMeteor = 3.5
        }
        
        
        //Animacion de meteoro
        for i in 1...30 {
            meteorAnimation.append(SKTexture(imageNamed: "rocks-\(i)"))
        }
        
        //Animacion de meteoro Power Up
        for i in 1...30 {
            powerUpMeteorAnimation.append(SKTexture(imageNamed: "small-rocks-\(i)"))
        }
        
        //Barra de disparo
        timesFire = SKSpriteNode(imageNamed: "0fires")
        timesFire.setScale(0.1 * scaleRatio)
        
        if scaleRatioiPhone5 == 1 {
            timesFire.position = CGPoint(x: self.frame.width / 2 - 150, y: self.frame.height / 2 + 120)
        }
            
        else if scaleRatioiPhone4 == 1 {
            timesFire.position = CGPoint(x: self.frame.width / 2 - 150, y: self.frame.height / 2 + 110)
            
        }
        else {
            timesFire.position = CGPoint(x: self.frame.width / 2 - 150, y: self.frame.height / 2 + 150)
        }
        
        addChild(timesFire)
        
        //Para la Fisica
        physicsWorld.contactDelegate = self
        
        //Timer para bajar la barra de disparo
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(0.3, target:self, selector: #selector(GameScene.bajarFireNumber), userInfo: nil, repeats: true)
        
        //Score

        scoreLabel = SKLabelNode(fontNamed: "VCR OSD Mono")
        if espanol {
            scoreLabel.text = "Puntaje \(score)"
        }
        else {
            scoreLabel.text = "Score \(score)"
        }
        scoreLabel.horizontalAlignmentMode = .Center
        scoreLabel.fontSize = 40
        
        if scaleRatioiPhone5 == 1 {
            scoreLabel.position = CGPoint(x: self.frame.width / 2 + 150, y: self.frame.height / 2 + 105)
        }
            
        else if scaleRatioiPhone4 == 1 {
            scoreLabel.position = CGPoint(x: self.frame.width / 2 + 150, y: self.frame.height / 2 + 95)
            
        }
        else {
            scoreLabel.position = CGPoint(x: self.frame.width / 2 + 150, y: self.frame.height / 2 + 135)
        }
        
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
        
        //Control
        
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
        
        // Timer para crear el obstaculo cada vez mas rapido
        
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
        switch currentDificulty {
        case .Easy:
            tiempoEntreCreacion = 1.8
        case .Medium:
            tiempoEntreCreacion = 1.3
        case .Hard:
            tiempoEntreCreacion = 0.6
        }
        
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
        
        let playMusic = defaults.boolForKey("Musica")
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == Fisica.bullets | Fisica.object {
            
            if contact.bodyA.node!.name == "meteor" {
                
                physicsObjectsToRemove.append(contact.bodyA.node!)
                physicsObjectsToRemove.append(disparo)
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyA.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                if playMusic == false {
                    self.runAction(explosion)
                }
                
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
                if playMusic == false {
                    self.runAction(explosion)
                }
                
                if alive {
                    score += 1
                }
            }
        }
        
        if collision == Fisica.bullets | Fisica.objectPowerUp {
            if contact.bodyA.node!.name == "powerUpMeteor" {
                
                physicsObjectsToRemove.append(contact.bodyA.node!)
                physicsObjectsToRemove.append(disparo)
                
                let sound = SKAction.playSoundFileNamed("powerUp", waitForCompletion: false)
                if playMusic == false {
                    self.runAction(sound)
                }
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyA.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                
                
                
                if alive {
                    score += 1
                }
                
                numberOfHits = 0
                objectAndPlayerCollides()
            }
                
            else if contact.bodyB.node!.name == "powerUpMeteor" {
                
                physicsObjectsToRemove.append(contact.bodyB.node!)
                physicsObjectsToRemove.append(disparo)
                
                let sound = SKAction.playSoundFileNamed("powerUp", waitForCompletion: false)
                if playMusic == false {
                    self.runAction(sound)
                }
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyB.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                
                
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
                    if playMusic == false {
                        self.runAction(explosion)
                    }
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
                if playMusic == false {
                    self.runAction(explosion)
                }
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
                    if playMusic == false {
                        self.runAction(explosion)
                    }
                }
                
            }
        } else if contact.bodyB.node!.name == "hero"  {
            
            physicsObjectsToRemove.append(contact.bodyA.node!)
            
            let fire = SKEmitterNode(fileNamed: "Fire")!
            fire.position = contact.bodyB.node!.position
            fire.numParticlesToEmit = 50
            addChild(fire)
            
            if alive {
                if playMusic == false {
                    self.runAction(explosion)
                }
            }
        }
        
    }
    
    override func didSimulatePhysics() {
        for node in physicsObjectsToRemove {
            node.removeFromParent()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        
        if espanol {
            scoreLabel.text = "Puntaje \(score)"
        }
        else {
            scoreLabel.text = "Score \(score)"
        }
        
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
        
        
        disparo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 3, height: 9))
        disparo.physicsBody?.dynamic = true
        disparo.physicsBody?.affectedByGravity = false
        
        disparo.physicsBody?.categoryBitMask    = Fisica.bullets
        disparo.physicsBody?.contactTestBitMask = Fisica.object
        disparo.physicsBody?.collisionBitMask   = Fisica.none

        
        let angle = CGVector(angle: getAngle())
        let vector = angle * 800
        print(angle, vector)
        
        disparo.physicsBody!.velocity = vector
        
        
        
        let fireSFX = SKAction.playSoundFileNamed("fireSound", waitForCompletion: false)
        
        
        if fireNumber < 4 {
            fireNumber += 1
        }
        
        if canFire == true {
            let playMusic = defaults.boolForKey("Musica")
            addChild(disparo)
            if playMusic == false {
                self.runAction(fireSFX)
            }
        }
        
    }
    
    func lost() {
        
        removeAllActions()
        stopBackGroundMusic()
        
        alive = false
        
        gameOver = SKLabelNode(fontNamed: "VCR OSD Mono")
        if espanol {
            gameOver.text = "¡Perdiste!"
        }
        else {
            gameOver.text = "Game Over!"
        }
        gameOver.horizontalAlignmentMode = .Center
        gameOver.fontSize = 50
        gameOver.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 50)
        addChild(gameOver)
        
        if espanol {
            restartButton = SKSpriteNode(imageNamed: "jugarDeNuevo")
        }
        else {
            restartButton = SKSpriteNode(imageNamed: "restart")
        }
        
        restartButton.name = "restart"
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 60)
        restartButton.setScale(0.08)
        addChild(restartButton)
        
        menuButton = SKSpriteNode(imageNamed: "menu")
        menuButton.name = "menu"
        menuButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 120)
        menuButton.setScale(0.08)
        addChild(menuButton)
        
        updateBestScore(score)
        
        loadAd()
        
    }
    
    func updateBestScore(score: Int) {
        
        switch currentDificulty {
        case .Easy:
            let actualBestScore = defaults.integerForKey("bestScoreEasy")
            
            if score > actualBestScore {
                defaults.setInteger(score, forKey: "bestScoreEasy")
            }
            
        case .Medium:
            let actualBestScore = defaults.integerForKey("bestScore")
            
            if score > actualBestScore {
                defaults.setInteger(score, forKey: "bestScore")
            }
        case .Hard:
            let actualBestScore = defaults.integerForKey("bestScoreHard")
            
            if score > actualBestScore {
                defaults.setInteger(score, forKey: "bestScoreHard")
            }
        }
    }
    
    func loadAd() {
        viewController.add()
        
    }
    
    func stopBackGroundMusic() {
        let path = NSBundle.mainBundle().pathForResource("backgroundSound.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            gameMusic = sound
            sound.stop()
            
        } catch {
            // couldn't load file :(
        }
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

