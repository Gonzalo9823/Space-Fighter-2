//
//  GameViewController.swift
//  NoName
//
//  Created by Gonzalo Caballero on 7/6/16.
//  Copyright (c) 2016 Gonzalo Caballero. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import FirebaseAuth

class GameViewController: UIViewController,GADInterstitialDelegate  {
    
    var interstitial: GADInterstitial!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MenuScene(size: view.frame.size)
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
        scene.viewController = self
        
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (anonymousUser: FIRUser?, error: NSError?) in
            if error == nil {
                
                print("User ID \(anonymousUser!.uid)")                
            } else {
                print(error!.localizedDescription)
                return
            }
        })
        
        
        interstitial = createAndLoadInterstitial()
        
        
    }
    
    
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func add() {
        if interstitial != nil {
            if ((interstitial?.isReady) != nil) {
                interstitial?.presentFromRootViewController(self)
            }
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1111040965253145/4016435916")
        request.testDevices = ["27496ACE-8FD5-4156-9B94-73DB4330EFB8"]
        
        interstitial.delegate = self
        interstitial.loadRequest(request)
        return interstitial
        
    }
    
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitial = createAndLoadInterstitial()
    }
}
