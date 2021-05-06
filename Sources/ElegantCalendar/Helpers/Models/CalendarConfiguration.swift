// Kevin Li - 10:51 PM - 6/6/20

import SwiftUI
import Foundation

/// Any changes to the configuration will reset the calendar based on its new settings
public struct CalendarConfiguration: Equatable {

    public let calendar: Calendar
    public let ascending: Bool
    public let startDate: Date
    public let endDate: Date
    public let yOffset: CGFloat?
    public var locale: Locale

    //public init(calendar: Calendar = .current, ascending: Bool = true, startDate: Date, endDate: Date, locale: Locale = .current) {
    public init(calendar: Calendar = .current,
                ascending: Bool = true,
                startDate: Date,
                endDate: Date,
                yOffset: CGFloat? = nil,
                locale: Locale = .current) {
        self.calendar = calendar
        self.ascending = ascending
        self.startDate = startDate
        self.endDate = endDate
        self.yOffset = yOffset
        self.locale = locale
    }

    var referenceDate: Date {
        ascending ? startDate : endDate
    }

}

extension CalendarConfiguration {

    static let mock = CalendarConfiguration(
        startDate: .daysFromToday(-365*2),
        endDate: .daysFromToday(365*2))

}

protocol ConfigurationDirectAccess {

    var configuration: CalendarConfiguration { get }

}

extension ConfigurationDirectAccess {

    var calendar: Calendar {
        configuration.calendar
    }

    var startDate: Date {
        configuration.startDate
    }

    var endDate: Date {
        configuration.endDate
    }

    var referenceDate: Date {
        configuration.referenceDate
    }

}
