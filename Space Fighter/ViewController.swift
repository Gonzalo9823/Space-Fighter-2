//
//  ViewController.swift
//  Space Fighter
//
//  Created by Gonzalo Caballero on 7/11/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    

    @IBOutlet weak var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-1111040965253145/4016435916"
        banner.rootViewController = self
        banner.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    
}
