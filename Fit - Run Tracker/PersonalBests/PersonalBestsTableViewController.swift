//
//  PersonalBestsTableViewController.swift
//  CG4 Coursework
//
//  Created by William Ray on 12/03/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class PersonalBestsTableViewController: UITableViewController {

    private let pbStore: StoreTableViewDataSource<PersonalBestStore, PersonalBestCellFactory> =
        StoreTableViewDataSource(source: PersonalBestStore(), reuseIdentifier: "personalBestCell", cellFactory: PersonalBestCellFactory())

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self.pbStore
    }

    override func viewWillAppear(_ animated: Bool) {
        pbStore.source.refresh()
    }

}
