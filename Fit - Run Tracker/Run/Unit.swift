//
//  Unit.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 22/09/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import Foundation

protocol ScientificUnit: Comparable {
    associatedtype SUnit

    var rawValue: Double { get set }

    init(rawValue: Double)
}

extension ScientificUnit {

    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

}

protocol UnitPreservingArithmetic: ScientificUnit {

    static func + (lhs: Self, rhs: Self) -> Self
    static func += (lhs: inout Self, rhs: Self)

    static func - (lhs: Self, rhs: Self) -> Self
    static func -= (lhs: inout Self, rhs: Self)

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
        return self.init(rawValue: lhs.rawValue + rhs.rawValue)
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs.rawValue += rhs.rawValue
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        return self.init(rawValue: lhs.rawValue + rhs.rawValue)
    }

    static func -= (lhs: inout Self, rhs: Self) {
        lhs.rawValue -= rhs.rawValue
    }

    static func * (lhs: Self, rhs: Double) -> Self {
        return self.init(rawValue: lhs.rawValue * rhs)
    }

    static func * (lhs: Double, rhs: Self) -> Self {
        return self.init(rawValue: lhs * rhs.rawValue)
    }

    static func * (lhs: Self, rhs: Int) -> Self {
        return self.init(rawValue: lhs.rawValue * Double(rhs))
    }

    static func * (lhs: Int, rhs: Self) -> Self {
        return self.init(rawValue: Double(lhs) * rhs.rawValue)
    }

    static func / (lhs: Self, rhs: Double) -> Self {
        return self.init(rawValue: lhs.rawValue / rhs)
    }

    static func / (lhs: Double, rhs: Self) -> Self {
        return self.init(rawValue: lhs / rhs.rawValue)
    }

    static func / (lhs: Self, rhs: Int) -> Self {
        return self.init(rawValue: lhs.rawValue / Double(rhs))
    }

    static func / (lhs: Int, rhs: Self) -> Self {
        return self.init(rawValue: Double(lhs) / rhs.rawValue)
    }

}
