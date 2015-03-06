//
//  AddNewShoeTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 05/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddNewShoeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            let actionMenu = UIAlertController(title: "Image", message: "", preferredStyle: .ActionSheet)
            actionMenu.addAction(UIAlertAction(title: "Take Photo", style: .Default, handler: { (action) -> Void in
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            actionMenu.addAction(UIAlertAction(title: "Choose Existing", style: .Default, handler: { (action) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            
            self.presentViewController(actionMenu, animated: true, completion: nil)
        }
    }

    // MARK: - Image Picker

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        selectedImage = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        /*
        let imageData = UIImagePNGRepresentation(image)
        let paths = NSSearchPathForDirectoriesInDomains(.PicturesDirectory, .UserDomainMask, true)[0] as String
        let imagePath = paths.stringByAppendingPathComponent("shoeName")
        
        if !imageData.writeToFile(imagePath, atomically: false)
        {
            println("Image not saved.")
        } else {
            println("Image saved successfully.")
        }
        */
        
    }
    
}
