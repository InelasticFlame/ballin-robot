//
//  Store.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 06/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

protocol Store {
    associatedtype StoreType

    var count: Int { get }

    func get(atIndex index: Int) -> StoreType
    func refresh() // PH until larger changes are made
    
}
