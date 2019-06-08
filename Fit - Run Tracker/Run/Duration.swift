//
//  Duration.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 08/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import Tagged

protocol DurationUnit {}

enum Seconds: DurationUnit {
    case unit
}

enum Minutes: DurationUnit {
    case unit
}

enum Hours: DurationUnit {
    case unit
}

typealias Duration = Tagged<DurationUnit, Double>
