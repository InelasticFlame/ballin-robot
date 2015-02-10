//
//  DatePickerViewController.swift
//  
//
//  Created by William Ray on 10/02/2015.
//
//

import UIKit

class DatePickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewHeight = self.view.frame.size.height
        let viewWidth = self.view.frame.size.width
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: viewWidth/2, height: viewHeight))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
