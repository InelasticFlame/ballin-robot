//
//  Duration.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 08/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

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

final class Duration<U: DurationUnit>: UnitPreservingArithmetic {
    typealias SUnit = U

    var rawValue: Double

    required init(rawValue: Double) {
        self.rawValue = rawValue
    }

    init(_ duration: Double) {
        self.rawValue = duration
    }
}

extension Duration where SUnit == Seconds {

    static func / (lhs: Duration, rhs: Distance<Miles>) -> Speed<SecondsPerMile> {
        return (lhs.rawValue / rhs.rawValue).secondsPerMile
    }

    static func / (lhs: Duration, rhs: Speed<SecondsPerMile>) -> Distance<Miles> {
        return (lhs.rawValue / rhs.rawValue).miles
    }

}

extension Double {

    var secs: Duration<Seconds> {
        return Duration<Seconds>(self)
    }

    var mins: Duration<Minutes> {
        return Duration<Minutes>(self)
    }

    var hrs: Duration<Hours> {
        return Duration<Hours>(self)
    }

}

extension Int {

    var secs: Duration<Seconds> {
        return Double(self).secs
    }

    var mins: Duration<Minutes> {
        return Double(self).mins
    }

    var hrs: Duration<Hours> {
        return Double(self).hrs
    }

}
