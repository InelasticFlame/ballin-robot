//
//  AddRunPickerViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 02/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class AddRunPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerValue = ""
    
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
    
    func setupPickerView() {
        
        switch pickerValue {
            case Constants.PickerViewTypes.Distance:
                println()
            case Constants.PickerViewTypes.Duration:
                println()
            case Constants.PickerViewTypes.Pace:
                println()
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
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return "\(row)"
        } else if component == 1 {
            return NSString(format: ".%02i", row)
        } else {
            return "unit"
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component != 2 {
            return 100
        } else {
            return 2
        }
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
