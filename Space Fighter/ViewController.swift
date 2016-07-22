//
//  ViewController.swift
//  Space Fighter
//
//  Created by Gonzalo Caballero on 7/11/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial?

    @IBAction func show(sender: AnyObject) {
        if interstitial != nil {
            if ((interstitial?.isReady) != nil) {
                interstitial?.presentFromRootViewController(self)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()
        // Do any additional setup after loading the view.
    }

    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: " ca-app-pub-1111040965253145/4016435916")
        
        interstitial.delegate = self
        interstitial.loadRequest(request)
        return interstitial
        
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitial = createAndLoadInterstitial()
    }
}
