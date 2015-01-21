//
//  HomeTableViewCell.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class HomeProgressTableViewCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressDetailLabel: UILabel!
    @IBOutlet var progressView: UIView!
    var progress = 0.0
    var loaded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Conversions().addBorderToView(self.headerView)
        Conversions().addBorderToView(self.mainView)
        let returnValues = self.loadMonthlyRunProgress()
        self.progress = returnValues.0
        self.progressDetailLabel.text = "\(returnValues.2) miles ran towards goal of \(returnValues.1)"
    }
    
    func setUpCell() {
        if !loaded {
            let progressBar = ProgressBar(progress: progress, frame: self.mainView.frame)
            progressBar.center = CGPoint(x: progressBar.center.x - 16, y: progressBar.center.y)
            self.progressView.addSubview(progressBar)
            self.progressLabel.text = NSString(format: "%1.0lf%%", progress*100)
            loaded = true
        }
    }
    
    func loadMonthlyRunProgress() -> (progress: Double, goalMiles: Double, totalMiles: Double) {
        let goalMiles = NSUserDefaults.standardUserDefaults().doubleForKey("goalDistance")
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
