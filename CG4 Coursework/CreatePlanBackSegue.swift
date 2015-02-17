//
//  CreatePlanBackSegue.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class CreatePlanBackSegue: UIStoryboardSegue {
    
    override func perform() {
        let sourceViewController = self.sourceViewController as UIViewController
        let destinationViewController = self.destinationViewController as UIViewController
        let navigationController = sourceViewController.navigationController as UINavigationController?
        
        if let navigationController = navigationController {
            navigationController.popToRootViewControllerAnimated(false)
            navigationController.pushViewController(destinationViewController, animated: true)
        }
    }
    
}
