//
//  AddNewShoeTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 05/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddNewShoeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var shoeNameTextField: UITextField!
    @IBOutlet weak var shoeDistancePicker: DistancePicker!
    
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
        self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))?.imageView?.image = selectedImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        if Database().shoeNameExists(shoeNameTextField.text.capitalizedStringWithLocale(NSLocale.currentLocale())) {
            //"A Shoe Name Must Be Unique"
        } else if selectedImage == nil {
            //"No image has been selected. Are you sure you wish to continue?"
        } else {
            saveShoe()
        }
    }
    
    func saveShoe() {
        var shoeNamePath = ""
        
        /* Save Image */
        if selectedImage != nil {
            let imageData = UIImagePNGRepresentation(selectedImage)
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            shoeNamePath = shoeNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil) + "\(arc4random() % 1000)"
            let imagePath = paths.stringByAppendingPathComponent("\(shoeNamePath).png")
            
            if !imageData.writeToFile(imagePath, atomically: false) {
                shoeNamePath = "NO_IMAGE"
                println("Image not saved.")
            } else {
                println("Image saved successfully.")
            }
        } else {
            shoeNamePath = "NO_IMAGE"
        }
        
        let shoe = Shoe(ID: 0, name: shoeNameTextField.text.capitalizedStringWithLocale(NSLocale.currentLocale()), miles: shoeDistancePicker.selectedDistance().distance, imagePath: shoeNamePath)
        Database().saveShoe(shoe)
        navigationController?.popViewControllerAnimated(true)
    }
    
}
