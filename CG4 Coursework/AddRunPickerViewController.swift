//
//  AddRunPickerViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 02/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddRunPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var numberOfComponents = 0
    var numberOfRows = [Int]()
    var componentFormat = [String]()
    var componentContent = [[String]()]
    
    
    var pickerNumberOfComponents = 0
    var pickerComponentRows = [Int]()
    var pickerUnits = [String]()
    
    init(pickerType: String) {
        super.init(nibName: nil, bundle: nil)
        
        setupPickerView(pickerType)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerViewHolder = UIView(frame: CGRect(x: 20, y: 300, width: self.view.frame.size.width - 40, height: 200))
        pickerViewHolder.backgroundColor = UIColor.grayColor()
        pickerViewHolder.layer.borderWidth = 5
        pickerViewHolder.layer.borderColor = UIColor.blackColor().CGColor
        self.view.addSubview(pickerViewHolder)
        
        let pickerView = UIPickerView(frame: CGRect(x: 10, y: 35, width: self.view.frame.size.width - 60, height: 120))
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = UIColor.lightGrayColor()
        pickerViewHolder.addSubview(pickerView)
        
        let cancelButton = UIButton(frame: CGRect(x: 8, y: 5 , width: 0, height: 0))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.sizeToFit()
        cancelButton.addTarget(self, action: "cancelPress:", forControlEvents: .TouchUpInside)
        pickerViewHolder.addSubview(cancelButton)
        
        let doneButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 96, y: 5, width: 0, height: 0))
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.addTarget(self, action: "donePress:", forControlEvents: .TouchUpInside)
        doneButton.sizeToFit()
        pickerViewHolder.addSubview(doneButton)
    }
    
    func setupPickerView(pickerType: String) {
        
        switch pickerType {
            case Constants.PickerViewTypes.Distance:
                numberOfComponents = Constants.PickerViewTypes.PickerViewAttributes.Distance.NumberOfComponents
                numberOfRows = Constants.PickerViewTypes.PickerViewAttributes.Distance.NumberOfRows
                componentFormat = Constants.PickerViewTypes.PickerViewAttributes.Distance.Format
                componentContent = Constants.PickerViewTypes.PickerViewAttributes.Distance.Content
            case Constants.PickerViewTypes.Duration:
                numberOfComponents = Constants.PickerViewTypes.PickerViewAttributes.Duration.NumberOfComponents
                numberOfRows = Constants.PickerViewTypes.PickerViewAttributes.Duration.NumberOfRows
                componentFormat = Constants.PickerViewTypes.PickerViewAttributes.Duration.Format
                componentContent = Constants.PickerViewTypes.PickerViewAttributes.Duration.Content
            case Constants.PickerViewTypes.Pace:
                numberOfComponents = Constants.PickerViewTypes.PickerViewAttributes.Pace.NumberOfComponents
                numberOfRows = Constants.PickerViewTypes.PickerViewAttributes.Pace.NumberOfRows
                componentFormat = Constants.PickerViewTypes.PickerViewAttributes.Pace.Format
                componentContent = Constants.PickerViewTypes.PickerViewAttributes.Pace.Content
            case Constants.PickerViewTypes.RunType:
                println()
            case Constants.PickerViewTypes.Shoe:
                println()
            default:
                println()
        }
    }
    
    func cancelPress(sender:UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func donePress(sender:UIButton!) {
        if let presentingVC = self.presentingViewController {
            for VC in presentingVC.childViewControllers {
                if let ViewC = VC as? AddRunTableViewController {
                    ViewC.updateDetail()
                }
            }
        }

        dismissViewControllerAnimated(true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - PickerView
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if componentContent[component][0] == "row" {
            return NSString(format: componentFormat[component], row)
        } else {
            return NSString(format: componentFormat[component], componentContent[component][row])
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfRows[component]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
