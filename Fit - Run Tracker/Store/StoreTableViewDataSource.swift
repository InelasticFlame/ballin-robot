//
//  StoreTableViewDataSource.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 06/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import UIKit

class StoreTableViewDataSource<Source: Store, Factory: CellFactory>: NSObject, UITableViewDataSource
    where Factory.CellContents == Source.StoreType, Factory.CellType: UITableViewCell {

    private let cellFactory: Factory
    private let reuseIdentifier: String

    var source: Source

    init(source: Source, reuseIdentifier: String, cellFactory: Factory) {
        self.source = source
        self.reuseIdentifier = reuseIdentifier
        self.cellFactory = cellFactory
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! Factory.CellType
        cellFactory.createCell(cell: cell, item: source.get(atIndex: indexPath.row))
        return cell
    }

}
