//
//  Distance.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 08/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

protocol DistanceUnit {}

enum Miles: DistanceUnit {
    case unit
}

enum Kilometres: DistanceUnit {
    case unit
}

final class Distance<U: DistanceUnit>: UnitPreservingArithmetic {
    typealias SUnit = U

    var rawValue: Double

    required init(rawValue: Double) {
        self.rawValue = rawValue
    }

    init(_ speed: Double) {
        self.rawValue = speed
    }

}

extension Distance where SUnit == Miles {

    convenience init(_ value: Double) {
        self.init(rawValue: value)
    }

    func toKilometres() -> Distance<Kilometres> {
        return Distance<Kilometres>(Conversions.milesToKm * self.rawValue)
    }

    func toString(_ unit: DistanceUnit) -> String {
        if unit is Kilometres {
            return (NSString(format: "%1.2f", self.toKilometres().rawValue) as String) + " km"
        }

        return (NSString(format: "%1.2f", self.rawValue) as String) + " miles"
    }

}

extension Distance where SUnit == Kilometres {

    convenience init(_ value: Double) {
        self.init(rawValue: value)
    }

    func toMiles() -> Distance<Miles> {
        return Distance<Miles>(Conversions.kmToMiles * self.rawValue)
    }

    func toString(_ unit: DistanceUnit) -> String {
        if unit is Kilometres {
            return (NSString(format: "%1.2f", self.rawValue) as String) + " km"
        }

        return (NSString(format: "%1.2f", self.toMiles().rawValue) as String) + " miles"
    }

}

extension Double {

    var miles: Distance<Miles> {
        return Distance<Miles>(self)
    }

    var metres: Distance<Kilometres> {
        return Distance<Kilometres>(Conversions.kmToM * self)
    }

    var kilometres: Distance<Kilometres> {
        return Distance<Kilometres>(self)
    }

}

extension Int {

    var miles: Distance<Miles> {
        return Double(self).miles
    }

    var metres: Distance<Kilometres> {
        return Double(self).metres
    }

    var kilometres: Distance<Kilometres> {
        return Double(self).kilometres
    }

}
