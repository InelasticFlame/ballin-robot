//
//  Date.swift
//  Fit - Run Tracker
//
//  Created by William Ray on 03/06/2019.
//  Copyright © 2019 William Ray. All rights reserved.
//

import DateToolsSwift

extension Date {

    private static let databaseFormat: String = "dd/MM/yyyyHH:mm:ss"
    private static let shortDateFormat: String = "dd/MM/yyyy"
    private static let shortestDateFormat: String = "dd/MM/YY"
    private static let monthYearDateFormat: String = "MM/yyyy"
    private static let twelveHourTimeFormat: String = "hh:mm a"

    public init (shortDateString: String) {
        self.init(dateString: shortDateString, format: Date.shortDateFormat)
    }

    public init (databaseString: String) {
        self.init(dateString: databaseString, format: Date.databaseFormat)
    }

    public var toDatabaseString: String { return self.format(with: Date.databaseFormat) }

    public var toShortDateString: String { return self.format(with: Date.shortDateFormat) }

    public var toShortestDateString: String { return self.format(with: Date.shortestDateFormat) }

    public var toMonthYearString: String { return self.format(with: Date.monthYearDateFormat) }

    public var to12HourTimeString: String { return self.format(with: Date.twelveHourTimeFormat) }

    public func startOfDay() -> Date {
        return Date(year: self.year, month: self.month, day: self.day)
    }

    public func endOfDay() -> Date {
        return Date(year: self.year, month: self.month, day: self.day, hour: 23, minute: 59, second: 59)
    }
}
