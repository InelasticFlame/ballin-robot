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
    This method is called by the system to perform the segue. It defines what the system should do in order to perform it.
    1. Declares the local constant sourceViewController
    2. Declares the local constant destinationViewController
    3. Declares the local constant naviagtionController
    4. IF there is a navigationController
        a. Moves to the rootViewController without an animation
        b. Presents the destinationViewController with an animation
    
    Uses the following local variables:
        sourceViewController - The view controller that the segue starts from
        destinationViewController - The view controller that the segue leads to
        navigationController - The main navigation controller of the system
    */
    override func perform() {
        let sourceViewController = self.source as UIViewController
        let destinationViewController = self.destination as UIViewController
        let navigationController = sourceViewController.navigationController as UINavigationController?

        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: false)
            navigationController.pushViewController(destinationViewController, animated: true)
        }
    }

}
