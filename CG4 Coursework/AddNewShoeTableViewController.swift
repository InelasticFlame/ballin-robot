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
    2. Tells the view controller to listen for the notification "UpdateDetailLabel" and to call the function updateDetailLabel wheneevr it receives this notification
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shoeNameTextField.delegate = self //1
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewShoeTableViewController.updateDetailLabel), name: NSNotification.Name(rawValue: "UpdateDetailLabel"), object: nil) //2
    }
    
    /**
    This method is called by the system whenever the view appears on screen. It calls the function updateDetailLabel (this needs to be called once the view has appeared so that the table view is fully loaded)
    
    :param: animated A boolean that indicates whether the view is being added to the window using an animation.
    */
    override func viewDidAppear(_ animated: Bool) {
        updateDetailLabel()
    }

    //MARK: - Text Field
    
    /**
    This method is called by the system when a user presses the return button on the keyboard whilst inputting into the text field.
    1. Dismisses the keyboard by removing the textField as the first responder for the view (the focus)
    2. Returns false
    
    :param: textField The UITextField whose return button was pressed.
    :returns: A boolean value indicating whether the text field's default behaviour should be perform (true) or not (false)
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //1
        
        return false //2
    }
    
    // MARK: - Table View Data Source
    
    /**
    This method is called by the system whenever a user selects a cell in the table view. If the user presses the Shoe Image cell it display as impage picker on the screen.
    1. IF the fifth cell is selected
        a. Create an image picker controller
        b. Sets the delegate (controller) of the image picker to this class
        c. Allows a user to edit an image they have selected in the image picker controller
        d. Creates a UIAlert with the title "Image" and the buttons "Take Photo", "Choose Existing" and "Cancel"
        e. When a user presses "Take Photo"
            i. Sets the image picker to be a camera view
           ii. Sets the camera to photos mode
          iii. Presents the image picker
        f. When a user presses "Choose Existing"
            i. Sets the image picker source to the Photos library
           ii. Presents the image picker
        g. When the user presses the "Cancel" button
            i. Dismiss the action menu
        h. Displays the UIAlert
    2. IF the third cell is selected
        i. Switches the value of showDistancePicker
        j. Calls the function reloadTableViewCells to adjust the cell heights
    3. Sets the cell that was selected to be deselected, animating the transition
    
    Uses the following local variables:
        imagePicker - The UIImagePickerController to create and configure before displaying to the user
        actionMenu - The UIAlertController to create and configure before displaying to the user
    
    :param: tableView The UITableView object informing the delegate about the new row selection.
    :param: indexPath The NSIndexPath of the row selected.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 { //1
            
            let imagePicker = UIImagePickerController() //a
            imagePicker.delegate = self //b
            imagePicker.allowsEditing = true //c
            
            let actionMenu = UIAlertController(title: "Image", message: "", preferredStyle: .actionSheet) //d
            actionMenu.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) -> Void in //e
                imagePicker.sourceType = .camera //i
                imagePicker.cameraCaptureMode = .photo //ii
                self.present(imagePicker, animated: true, completion: nil) ///iii
            }))
            actionMenu.addAction(UIAlertAction(title: "Choose Existing", style: .default, handler: { (action) -> Void in //f
                imagePicker.sourceType = .photoLibrary //i
                self.present(imagePicker, animated: true, completion: nil) //ii
            }))
            actionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) //g //i
            
            self.present(actionMenu, animated: true, completion: nil) //h
        } else if indexPath.row == 2 { //2
            showDistancePicker = !showDistancePicker //i
            tableView.reloadTableViewCells() //j
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true) //3
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
    
    :param: tableView The UITableView that is requesting the information from the delegate.
    :param: indexPath The NSIndexPath of the row that's height is being requested.
    :returns: A CGFloat value that is the rows height.
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    This method updates the text of the distance detail label in the current distance cell.
    */
    func updateDetailLabel() {
        tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.text = shoeDistancePicker.selectedDistance().distanceStr
    }

    // MARK: - Image Picker

    /**
    This method is called by the system when a user selects an image using the ImagePickerController. It stores the image in the global selectedImage variable and displays it on the interface.
    1. Sets the selectedImage to the image selected using the image picker controller
    2. Sets the shoeImageView's image to the selected image
    3. Calls the function reloadTableViewCells
    4. Dismisses the image picker view controller and animates the transition
    
    :param: picker The UIImagePickerController managing the image picker interface.
    :param: image The UIImage selected by the user.
    :param: editingInfo An NSDictionary containing any relevant editing information.
    */
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        selectedImage = image //1
        shoeImageView.image = selectedImage //2
        
        tableView.reloadTableViewCells() //3
        
        picker.dismiss(animated: true, completion: nil) //4
    }
    
    // MARK: - Navigation
    
    /**
    This method is called by the system when a user presses the Save button. If a shoe passes all the validation checks the saveShoe function will be called.
    1. Declares the local constant UITableViewCell; errorCell that stores a reference to the cell that displays the error message
    2. Declares the local tuple shoeNameValidation and stores the return of the validateString function performed on the string in the shoeNameTextField
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
    
    Uses the following local variables:
        errorCell - The UITableViewCell that will contain the error message
        shoeNameValidation - A tuple of (boolean, string) that stores whether the plan name is valid and if it isn't any error that there is
        actionMenu - The UIAlertController to create and configure before displaying to the user
    
    :param: sender The object that called the action (in this case the Save button).
    */
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let errorCell = tableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) //1
        
        let shoeNameValidation = shoeNameTextField.text!.validateString(stringName: "Shoe Name", maxLength: 30, minLength: 3) //2
        if shoeNameValidation.valid { //3
            
            let shoeName = shoeNameTextField.text ?? ""
            if Database().shoeNameExists(shoeName.capitalized) { //a
                errorCell?.textLabel?.text = "A shoe name must be unique." //i
                showError = true //ii
                tableView.reloadTableViewCells() //iii
            } else if selectedImage == nil { //b
                let actionMenu = UIAlertController(title: "No Image", message: "No image has been selected for this shoe. Continue?", preferredStyle: .alert) //iv
                actionMenu.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil)) //v
                actionMenu.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in //vi
                    self.saveShoe()
                    actionMenu.dismiss(animated: true, completion: nil)
                }))
                self.present(actionMenu, animated: true, completion: nil) //vii
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
    This method is used to save a shoe if all validation checks have been passed successfully. It then dismisses the view.
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
    
    Uses the following local variables:
        shoeNamePath - A string variable that stores the shoe name part of the image path
        imageData - Constant NSData object that stores the image in a form that can be saved
        documentsPath - A constant string that is the path to the documents folder
        imagePath - A constant string that is the full image path
        shoe - A constant Shoe object that is the shoe to be saved to the database
    */
    func saveShoe() {
        var shoeNamePath = ""
        
        /* Save Image */
        if selectedImage != nil {
            let imageData = UIImagePNGRepresentation(selectedImage!)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            shoeNamePath = (shoeNameTextField.text?.replacingOccurrences(of: " ", with: ""))!
            let imagePath = NSURL(fileURLWithPath: documentsPath).appendingPathComponent("\(shoeNamePath).png")

            
            do {
                try imageData?.write(to: imagePath!)
                print("Image saved successfully.")
            }
            catch {
                shoeNamePath = "NO_IMAGE"
                print("Image not saved.")
            }

        } else {
            shoeNamePath = "NO_IMAGE"
        }
        
        let shoeName = shoeNameTextField.text ?? ""
        
        let shoe = Shoe(ID: 0, name: shoeName.capitalized, miles: shoeDistancePicker.selectedDistance().distance, imageName: shoeNamePath)
        Database().saveShoe(shoe)
        navigationController?.popViewController(animated: true)
    }
    
}
