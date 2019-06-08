//
//  Speed.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 08/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import Tagged

protocol SpeedUnit {}

enum MetresPerSecond: SpeedUnit {
    case unit
}

enum KilometresPerHour: SpeedUnit {
    case unit
}

enum MinutesPerMile: SpeedUnit {
    case unit
}

enum MilesPerHour: SpeedUnit {
    case unit
}

typealias Speed<T> = Tagged<SpeedUnit, Double>
