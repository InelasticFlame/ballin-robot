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
    
    var pickerView = UIPickerView()
    var pickerType = ""
    
    init(pickerType: String) {
        super.init(nibName: nil, bundle: nil)
        self.pickerType = pickerType
        
        setupPickerView(pickerType)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let windowHeight = self.view.frame.size.height
        let windowWidth = self.view.frame.size.width
            
        let pickerViewHolder = UIView(frame: CGRect(x: 20, y: windowHeight - 249, width: windowWidth - 40, height: 200))
        pickerViewHolder.backgroundColor = UIColor.grayColor()
        pickerViewHolder.layer.borderWidth = 5
        pickerViewHolder.layer.borderColor = UIColor.blackColor().CGColor
        self.view.addSubview(pickerViewHolder)
        
        pickerView = UIPickerView(frame: CGRect(x: 10, y: 35, width: windowWidth - 60, height: 120))
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = UIColor.lightGrayColor()
        pickerViewHolder.addSubview(pickerView)
        
        let cancelButton = UIButton(frame: CGRect(x: 8, y: 5 , width: 0, height: 0))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.sizeToFit()
        cancelButton.addTarget(self, action: "cancelPress:", forControlEvents: .TouchUpInside)
        pickerViewHolder.addSubview(cancelButton)
        
        let doneButton = UIButton(frame: CGRect(x: windowWidth - 96, y: 5, width: 0, height: 0))
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.addTarget(self, action: "donePress:", forControlEvents: .TouchUpInside)
        doneButton.sizeToFit()
        pickerViewHolder.addSubview(doneButton)
    }

    func setupPickerView(pickerType: String) {
        
        switch pickerType {
            case Constants.PickerView.Type.Distance:
                numberOfComponents = Constants.PickerView.Attributes.Distance.NumberOfComponents
                numberOfRows = Constants.PickerView.Attributes.Distance.NumberOfRows
                componentFormat = Constants.PickerView.Attributes.Distance.Format
                componentContent = Constants.PickerView.Attributes.Distance.Content
            case Constants.PickerView.Type.Duration:
                numberOfComponents = Constants.PickerView.Attributes.Duration.NumberOfComponents
                numberOfRows = Constants.PickerView.Attributes.Duration.NumberOfRows
                componentFormat = Constants.PickerView.Attributes.Duration.Format
                componentContent = Constants.PickerView.Attributes.Duration.Content
            case Constants.PickerView.Type.Pace:
                numberOfComponents = Constants.PickerView.Attributes.Pace.NumberOfComponents
                numberOfRows = Constants.PickerView.Attributes.Pace.NumberOfRows
                componentFormat = Constants.PickerView.Attributes.Pace.Format
                componentContent = Constants.PickerView.Attributes.Pace.Content
            case Constants.PickerView.Type.RunType:
                println()
            case Constants.PickerView.Type.Shoe:
                println()
            default:
                println("Error Setting Up PickerView for type: \(pickerType)")
        }
    }
    
    func cancelPress(sender:UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func donePress(sender:UIButton!) {
        if let presentingVC = self.presentingViewController {
            for viewController in presentingVC.childViewControllers {
                if let previousVC = viewController as? AddRunTableViewController {
                    var returnValues = [String]()
                    
                    for var i = 0; i < numberOfComponents; i++ {
                        let value = self.pickerView(pickerView, titleForRow: pickerView.selectedRowInComponent(i), forComponent: i)
                        
                        returnValues.append(value)
                    }
                    
                    previousVC.updateDetail(returnValues)
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
