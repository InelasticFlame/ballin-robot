//
//  FirstViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        StravaAuth.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func exchangeToken(code: String) {
        
    }
    
    @IBAction func authorise(AnyObject) {
        StravaAuth().authorise()
    }
    
    @IBAction func loadRuns(AnyObject) {
        StravaRuns().loadRunsFromStrava()
    }

}

