//
//  AddNewShoeTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 05/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddNewShoeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Storyboard Links
    /* These variables store links to controls on the interface, connected via the Storyboard. */
    @IBOutlet weak var shoeNameTextField: UITextField!
    @IBOutlet weak var shoeDistancePicker: DistancePicker!
    @IBOutlet weak var shoeImageView: UIImageView!
    
    //MARK: - Global Variables
    
    private weak var selectedImage: UIImage? //A global optional UIImage variable that stores the image a user has selected (if they have selected one)
    private var showError = false //A global boolean variable that stores whether or not to show the error cell
    private var showDistancePicker = false //A global boolean variable that stores whether or not the distance picker should be shown
    
    //MARK: - View Life Cycle
    
    /**
    This method is called by the system when the view is initially loaded.
    1. Sets the delegate (controller) of the shoeNameTextField to this view controller
    2. Tells the view controller to listen for the notification "UpdateDetailLabel" and to call the function updateDetailLabel wheneevr it recieves this notification
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shoeNameTextField.delegate = self //1
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDetailLabel", name: "UpdateDetailLabel", object: nil) //2
    }
    
    /**
    This method is called by the system whenever the view appears on screen. It calls the function updateDetailLabel (this needs to be called once the view has appeared so that the table view is fully loaded)
    */
    override func viewDidAppear(animated: Bool) {
        updateDetailLabel()
    }

    //MARK: - Text Field
    
    /**
    This method is called by the system when a user presses the return button on the keyboard whilst inputting into the text field.
    1. Dismisses the keyboard by removing the textField as the first responder for the view (the focus)
    2. Returns false
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() //1
        
        return false //2
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            
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
            actionMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(actionMenu, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            showDistancePicker = !showDistancePicker
            tableView.reloadTableViewCells()
        }
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 && showError {
            return Constants.TableView.DefaultRowHeight
        } else if indexPath.row == 3 && showDistancePicker {
            return Constants.TableView.PickerRowHeight
        } else if selectedImage != nil && indexPath.row == 5 {
            return Constants.TableView.ImageRowHeight
        } else if indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 {
            return 0
        } else {
            return Constants.TableView.DefaultRowHeight
        }
    }
    
    func updateDetailLabel() {
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))?.detailTextLabel?.text = shoeDistancePicker.selectedDistance().distanceStr
    }

    // MARK: - Image Picker

    /**
    This method is called by the system when a user selects an image using the ImagePickerController.
    1. Sets the selectedImage to the image selected using the image picker controller
    2. Sets the shoeImageView's image to the selected image
    3. Calls the function reloadTableViewCells
    4. Dismisses the image picker view controller and animates the transition
    */
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        selectedImage = image //1
        shoeImageView.image = selectedImage //2
        
        tableView.reloadTableViewCells() //3
        
        picker.dismissViewControllerAnimated(true, completion: nil) //4
    }
    
    // MARK: - Navigation
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let errorCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        
        let shoeNameValidation = shoeNameTextField.text.validateString("Shoe Name", maxLength: 30, minLength: 3)
        if shoeNameValidation.valid {
            
            if Database().shoeNameExists(shoeNameTextField.text.capitalizedStringWithLocale(NSLocale.currentLocale())) {
                errorCell?.textLabel?.text = "A shoe name must be unique."
                showError = true
                tableView.reloadTableViewCells()
            } else if selectedImage == nil {
                let actionMenu = UIAlertController(title: "No Image", message: "No image has been selected for this shoe. Continue?", preferredStyle: .Alert)
                actionMenu.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
                actionMenu.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                    self.saveShoe()
                    actionMenu.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(actionMenu, animated: true, completion: nil)
            } else {
                saveShoe()
            }
        } else {
            errorCell?.textLabel?.text = shoeNameValidation.error
            showError = true
            tableView.reloadTableViewCells()
        }
    }
    
    //MARK: - Shoe Saving
    
    func saveShoe() {
        var shoeNamePath = ""
        
        /* Save Image */
        if selectedImage != nil {
            let imageData = UIImagePNGRepresentation(selectedImage)
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            shoeNamePath = shoeNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
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
        
        let shoe = Shoe(ID: 0, name: shoeNameTextField.text.capitalizedStringWithLocale(NSLocale.currentLocale()), miles: shoeDistancePicker.selectedDistance().distance, imageName: shoeNamePath)
        Database().saveShoe(shoe)
        navigationController?.popViewControllerAnimated(true)
    }
    
}
