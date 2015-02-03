//
//  HomeTableViewCell.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class HomeProgressTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressDetailLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    var progress = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Conversions().addBorderToView(self.headerView)
        Conversions().addBorderToView(self.mainView)
        let returnValues = self.loadMonthlyRunProgress()
        self.progress = returnValues.0
        self.progressDetailLabel.text = "\(returnValues.2) miles of \(returnValues.1) completed."
    }
    
    func setUpCell() {
        let progressBar = ProgressBar(progress: progress, frame: self.mainView.frame)
        progressBar.center = CGPoint(x: progressBar.center.x - 16, y: progressBar.center.y)
        self.progressView.addSubview(progressBar)
        self.progressLabel.text = NSString(format: "%1.0lf%%", progress*100)
    }
    
    func loadMonthlyRunProgress() -> (progress: Double, goalMiles: Double, totalMiles: Double) {
        let goalMiles = NSUserDefaults.standardUserDefaults().doubleForKey(Constants.DefaultsKeys.Distance.GoalKey)
        let currentMonth = Conversions().dateToMonthString(NSDate())
        let runs: Array<Run> = Database().loadRunsWithQuery("WHERE RunDateTime LIKE '___\(currentMonth)%'") as Array<Run>
        let totalMiles = Conversions().totalUpRunMiles(runs)
        var progress = totalMiles/goalMiles
        if progress > 1 {
            progress = 1
        }
        
        return (progress, goalMiles, totalMiles)
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
