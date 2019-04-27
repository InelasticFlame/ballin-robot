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

    var count: Int { return runs.count }
    var runs: [Run] = []

    init() {
        refresh()
    }

    func get(atIndex index: Int) -> Run {
        return runs[index]
    }

    func remove(atIndex index: Int) {
        let run = runs.remove(at: index)
        Database().deleteRun(run)
    }

    func refresh() {
        self.runs = Database().loadRuns(withQuery: "") as! [Run]
    }

}
