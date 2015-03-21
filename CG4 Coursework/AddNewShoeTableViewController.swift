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
    
    /**
    This method is called by the system whenever a user selects a cell in the table view.
    1. IF the fifth cell is selected
        a. Create an image picker controller
        b. Sets the delegate (controller) of the image picker to this class
        c. Allows a user to edit an image they have selected in the image picker controller
        d. Creates a UIAlert with the title "Image" and the buttons "Take Photo", "Choose Existing" and "Cancel"
        e. When a user presses "Take Photo"
            i. Sets the image picker to be a camera view
           ii. Sets the camera to photos mode
          iii. Presents the image picker
        f. When a user presses "Choose Exisitng"
            i. Sets the image picker source to the Photos library
           ii. Presents the image picker
        g. When the user presses the "Cancel" button
            i. Dismiss the action menu
        h. Displays the UIAlert
    2. IF the third cell is selected
        i. Switches the value of showDistancePicker
        j. Calls the function reloadTableViewCells to adjust the cell heights
    3. Sets the cell that was selected to be deselected, animating the transition
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 { //1
            
            let imagePicker = UIImagePickerController() //a
            imagePicker.delegate = self //b
            imagePicker.allowsEditing = true //c
            
            let actionMenu = UIAlertController(title: "Image", message: "", preferredStyle: .ActionSheet) //d
            actionMenu.addAction(UIAlertAction(title: "Take Photo", style: .Default, handler: { (action) -> Void in //e
                imagePicker.sourceType = .Camera //i
                imagePicker.cameraCaptureMode = .Photo //ii
                self.presentViewController(imagePicker, animated: true, completion: nil) ///iii
            }))
            actionMenu.addAction(UIAlertAction(title: "Choose Existing", style: .Default, handler: { (action) -> Void in //f
                imagePicker.sourceType = .PhotoLibrary //i
                self.presentViewController(imagePicker, animated: true, completion: nil) //ii
            }))
            actionMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)) //g //i
            
            self.presentViewController(actionMenu, animated: true, completion: nil) //h
        } else if indexPath.row == 2 { //2
            showDistancePicker = !showDistancePicker //i
            tableView.reloadTableViewCells() //j
        }
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true) //3
    }
    
    /**
    This method is called by the system whenever the data is loaded in the table view. It returns the height for a row at a specified index path.
    1. IF the current row is the second row and the error should be shown (the error message cell for a validation error)
        a. Return the default row height
    2. IF the current row is the fourth row and the distance picker should be shown
        b. Return the picker row height
    3. IF there is an image selected and the current row is the sixth row
        c. Return the image row height
    4. IF the second, fourth or sixth row is the current row (if they haven't had a height set already they should be hidden)
        d. Return 0
    5. ELSE
        e. Return the default row height
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 && showError { //1
            return Constants.TableView.DefaultRowHeight //a
        } else if indexPath.row == 3 && showDistancePicker { //2
            return Constants.TableView.PickerRowHeight //b
        } else if selectedImage != nil && indexPath.row == 5 { //3
            return Constants.TableView.ImageRowHeight //c
        } else if indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 { //4
            return 0 //d
        } else { //5
            return Constants.TableView.DefaultRowHeight //e
        }
    }
    
    /**
    */
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
    
    /**
    This method is called by the system when a user presses the Save button. If a plan passes all the validation checks it will be saved.
    1. Declares the local constant UITableViewCell; errorCell that stores a reference to the cell that displays the error message
    2. Decalres the local tuple shoeNameValidation and stores the return of the validateString function performed on the string in the shoeNameTextField
    3. IF the shoeName is valid
        a. IF a shoe exists with the current name
            i. Sets the error cell text to be "A shoe name must be unique."
           ii. Sets showError to be true
          iii. Calls the function reloadTableViewCells
        b. ELSE IF there is no image selected
           iv. Creates a UIAlert with the options "Yes" and "No" and the warning that no image has been selected.
            v. When a user presses "No", do nothing just dismiss the alert
           vi. When a user presses Yes call the function saveShoe and dismiss the UIAlert
          vii. Present the UIAlert
        c. ELSE
         viii. Call the function saveShoe
    4. ELSE (when the shoe name is not valid)
        d. Sets the error cell text to the validation error
        e. Sets showError to be true
        f. Calls the function reloadTableViewCells
    */
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let errorCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) //1
        
        let shoeNameValidation = shoeNameTextField.text.validateString("Shoe Name", maxLength: 30, minLength: 3) //2
        if shoeNameValidation.valid { //3
            
            if Database().shoeNameExists(shoeNameTextField.text.capitalizedStringWithLocale(NSLocale.currentLocale())) { //a
                errorCell?.textLabel?.text = "A shoe name must be unique." //i
                showError = true //ii
                tableView.reloadTableViewCells() //iii
            } else if selectedImage == nil { //b
                let actionMenu = UIAlertController(title: "No Image", message: "No image has been selected for this shoe. Continue?", preferredStyle: .Alert) //iv
                actionMenu.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil)) //v
                actionMenu.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in //vi
                    self.saveShoe()
                    actionMenu.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(actionMenu, animated: true, completion: nil) //vii
            } else { //c
                saveShoe() //viii
            }
        } else { //4
            errorCell?.textLabel?.text = shoeNameValidation.error //d
            showError = true //e
            tableView.reloadTableViewCells() //f
        }
    }
    
    //MARK: - Shoe Saving
    
    /**
    This method is used to save a shoe if all validation checks have been passed successfully.
    1. Declares the local string variable shoeNamePath
    2. IF there is an image selected
        a. Convert the image into an NSData object to save in the documents directory
        b. Load the path of the documents directory
        c. Creates the shoeName part of the path by removing all spaces from the shoe name
        d. Create the imagePath by appending the shoeNamePath.png to the documentsPath
        e. IF the image does not write to the file successfully
            i. Sets the shoeNamePath to "NO_IMAGE"
           ii. Logs "Image not saved."
        f. ELSE
          iii. Logs "Image saved successfully."
    3. ELSE sets the shoeNamePath to "NO_IMAGE"
    4. Creates the shoe using the values from the interface
    5. Calls the function saveShoe from the database class passing the shoe
    6. Dismisses this view controller, animating the transition
    */
    func saveShoe() {
        var shoeNamePath = ""
        
        /* Save Image */
        if selectedImage != nil {
            let imageData = UIImagePNGRepresentation(selectedImage)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            shoeNamePath = shoeNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
            let imagePath = documentsPath.stringByAppendingPathComponent("\(shoeNamePath).png")
            
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
