//
//  CreatePlanBackSegue.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class CreatePlanBackSegue: UIStoryboardSegue {
    /* This class implements a custom segue to perform when the Create button is pressed on the InitialCreatePlanView */
    /* It removes the InitialCreatePlanViewController from the system and then presents the destinationViewController, this is so that a user cannot go back to this screen once they progress to the next view */
    
    /**
    1. Declares the local constant sourceViewController
    2. Declares the local constant destinationViewController
    3. Decalres the local constant naviagtionController
    4. IF there is a navigationController
        a. Moves to the rootViewController without an animation
        b. Presents the destinationViewController with an animation
    */
    override func perform() {
        let sourceViewController = self.sourceViewController as UIViewController //The view controller that the segue starts from
        let destinationViewController = self.destinationViewController as UIViewController //The view controller that the segue leads to
        let navigationController = sourceViewController.navigationController as UINavigationController? //The main navigation controller of the system
        
        if let navigationController = navigationController {
            navigationController.popToRootViewControllerAnimated(false)
            navigationController.pushViewController(destinationViewController, animated: true)
        }
    }
    
}
