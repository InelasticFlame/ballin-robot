//
//  CellFactory.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 06/04/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

protocol CellFactory {
    associatedtype CellContents
    associatedtype CellType

    func createCell(cell: CellType, item: CellContents)
}
