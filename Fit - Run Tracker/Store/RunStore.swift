//
//  RunStore.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 06/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import UIKit

class RunStore: Store {
    typealias StoreType = Run

    var count: Int
    var runs: [Run] = []

    init() {
        self.runs = Database().loadRuns(withQuery: "") as! [Run]
        self.count = self.runs.count
    }

    init(runs: [Run]) {
        self.runs = runs
        self.count = runs.count
    }

    func get(atIndex index: Int) -> Run {
        return runs[index]
    }

}

class RunCellFactory: CellFactory {
    typealias CellContents = Run

    func createCell(cell: UITableViewCell, item: Run) {
        
    }
}
