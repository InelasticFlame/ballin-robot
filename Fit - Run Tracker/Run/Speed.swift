//
//  Speed.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 08/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

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

protocol ScientificUnit: RawRepresentable where RawValue == Double {
    associatedtype SUnit
}

protocol UnitPreservingArithmetic: ScientificUnit {

    static func + (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self

    static func * (lhs: Self, rhs: Double) -> Self
    static func * (lhs: Double, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Int) -> Self
    static func * (lhs: Int, rhs: Self) -> Self

    static func / (lhs: Self, rhs: Double) -> Self
    static func / (lhs: Double, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Int) -> Self
    static func / (lhs: Int, rhs: Self) -> Self

}

extension UnitPreservingArithmetic {

    static func + (lhs: Self, rhs: Self) -> Self {
        return self.init(rawValue: lhs.rawValue + rhs.rawValue)!
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        return self.init(rawValue: lhs.rawValue + rhs.rawValue)!
    }

    static func * (lhs: Self, rhs: Double) -> Self {
        return self.init(rawValue: lhs.rawValue * rhs)!
    }

    static func * (lhs: Double, rhs: Self) -> Self {
        return self.init(rawValue: lhs * rhs.rawValue)!
    }

    static func * (lhs: Self, rhs: Int) -> Self {
        return self.init(rawValue: lhs.rawValue * Double(rhs))!
    }

    static func * (lhs: Int, rhs: Self) -> Self {
        return self.init(rawValue: Double(lhs) * rhs.rawValue)!
    }

    static func / (lhs: Self, rhs: Double) -> Self {
        return self.init(rawValue: lhs.rawValue / rhs)!
    }

    static func / (lhs: Double, rhs: Self) -> Self {
        return self.init(rawValue: lhs / rhs.rawValue)!
    }

    static func / (lhs: Self, rhs: Int) -> Self {
        return self.init(rawValue: lhs.rawValue / Double(rhs))!
    }

    static func / (lhs: Int, rhs: Self) -> Self {
        return self.init(rawValue: Double(lhs) / rhs.rawValue)!
    }

}

class Speed<U: SpeedUnit>: UnitPreservingArithmetic {
    typealias SUnit = U

    var rawValue: Double

    required init?(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    init(_ speed: Double) {
        self.rawValue = speed
    }
}

extension Double {

    var minutesPerMile: Speed<MinutesPerMile> {
        return Speed<MinutesPerMile>(self)
    }

    var kph: Speed<KilometresPerHour> {
        return Speed<KilometresPerHour>(self)
    }

}

extension Int {

    var minutesPerMile: Speed<MinutesPerMile> {
        return Double(self).minutesPerMile
    }

    var kph: Speed<KilometresPerHour> {
        return Double(self).kph
    }

}
