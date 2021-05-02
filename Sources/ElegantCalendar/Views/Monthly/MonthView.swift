// Kevin Li - 10:53 PM - 6/6/20

import SwiftUI

struct MonthView: View, MonthlyCalendarManagerDirectAccess {

    @Environment(\.calendarTheme) var theme: CalendarTheme

    @ObservedObject var calendarManager: MonthlyCalendarManager

    let month: Date
    
    let dateFormatter = DateFormatter()

    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        return calendar.generateDates(
            inside: monthInterval,
            matching: calendar.firstDayOfEveryWeek)
    }

    private var isWithinSameMonthAndYearAsToday: Bool {
        calendar.isDate(month, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        VStack(spacing: 40) {
            monthYearHeader
                .padding(.leading, CalendarConstants.Monthly.outerHorizontalPadding)
                .onTapGesture { self.communicator?.showYearlyView() }
            weeksViewWithDaysOfWeekHeader
            if selectedDate != nil {
                calenderAccessoryView
                    .padding(.leading, CalendarConstants.Monthly.outerHorizontalPadding)
                    .id(selectedDate!)
            }
            Spacer()
        }
        .padding(.top, CalendarConstants.Monthly.topPadding)
        .frame(width: CalendarConstants.Monthly.cellWidth, height: CalendarConstants.cellHeight)
    }

}

private extension MonthView {

    var monthYearHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                monthText
                yearText
            }
            Spacer()
        }
    }

    var monthText: some View {
        // localize this
        dateFormatter.locale = self.calendarManager.configuration.locale
        dateFormatter.dateFormat = "MMMM"
        //Text(month.fullMonth.uppercased())
        //Text(month.fullMonth)
        return Text(dateFormatter.string(from: month).firstCapitalized)
            //.font(.system(size: 26))
            .font(.title)
            //.bold()
            //.tracking(7)
            .foregroundColor(isWithinSameMonthAndYearAsToday ? Color(#colorLiteral(red: 0.438621819, green: 0.7752870917, blue: 0.6692710519, alpha: 1))  : .primary)
    }

    var yearText: some View {
        Text(month.year)
            .font(.system(size: 12))
            .tracking(2)
            .foregroundColor(isWithinSameMonthAndYearAsToday ? Color(#colorLiteral(red: 0.438621819, green: 0.7752870917, blue: 0.6692710519, alpha: 1)) : .gray)
            .opacity(0.95)
    }

}

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

private extension MonthView {

    var weeksViewWithDaysOfWeekHeader: some View {
        VStack(spacing: 32) {
            daysOfWeekHeader
            weeksViewStack
        }
    }

    var daysOfWeekHeader: some View {
        // localize this
        //dateFormatter.locale = self.calendarManager.configuration.locale
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = self.calendarManager.configuration.locale
        return HStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(calendar.veryShortWeekdaySymbols, id: \.self) { dayOfWeek in
                //Text(dateFormatter.string(from: dayOfWeek))
                Text(dayOfWeek)
                    .font(.caption)
                    .frame(width: CalendarConstants.Monthly.dayWidth)
                    .foregroundColor(.gray)
            }
        }
    }

    var weeksViewStack: some View {
        VStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(weeks, id: \.self) { week in
                WeekView(calendarManager: self.calendarManager, week: week)
            }
        }
    }

}

private extension MonthView {

    var calenderAccessoryView: some View {
        CalendarAccessoryView(calendarManager: calendarManager)
    }

}

private struct CalendarAccessoryView: View, MonthlyCalendarManagerDirectAccess {

    let calendarManager: MonthlyCalendarManager

    @State private var isVisible = false
    
    let dateFormatter = DateFormatter()

    private var numberOfDaysFromTodayToSelectedDate: Int {
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfSelectedDate = calendar.startOfDay(for: selectedDate!)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfSelectedDate).day!
    }

    private var isNotYesterdayTodayOrTomorrow: Bool {
        abs(numberOfDaysFromTodayToSelectedDate) > 1
    }

    var body: some View {
        VStack {
            selectedDayInformationView
            GeometryReader { geometry in
                self.datasource?.calendar(viewForSelectedDate: self.selectedDate!,
                                          dimensions: geometry.size)
            }
        }
        .onAppear(perform: makeVisible)
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.5))
    }

    private func makeVisible() {
        isVisible = true
    }

    private var selectedDayInformationView: some View {
        HStack {
            VStack(alignment: .leading) {
                // localize this
                dayOfWeekWithMonthAndDayText
//                if isNotYesterdayTodayOrTomorrow {
//                    daysFromTodayText
//                }
            }
            Spacer()
        }
    }

    private var dayOfWeekWithMonthAndDayText: some View {
        dateFormatter.locale = self.calendarManager.configuration.locale
        dateFormatter.dateFormat = "MMMM d"
        let monthDayText: String
        if numberOfDaysFromTodayToSelectedDate == -1 {
            //monthDayText = "Yesterday"
            monthDayText = "Ayer, " + dateFormatter.string(from: selectedDate!)
        } else if numberOfDaysFromTodayToSelectedDate == 0 {
            //monthDayText = "Today"
            monthDayText = "Hoy, " + dateFormatter.string(from: selectedDate!)
        } else if numberOfDaysFromTodayToSelectedDate == 1 {
            //monthDayText = "Tomorrow"
            monthDayText = "Mañana, " + dateFormatter.string(from: selectedDate!)
        } else {
            dateFormatter.dateFormat = "EEEE, MMMM d"
            monthDayText = dateFormatter.string(from: selectedDate!)
            //monthDayText = selectedDate!.dayOfWeekWithMonthAndDay
        }

        return Text(monthDayText.uppercased())
            .font(.subheadline)
            .bold()
    }

    private var daysFromTodayText: some View {
        let isBeforeToday = numberOfDaysFromTodayToSelectedDate < 0
        let daysDescription = isBeforeToday ? "DAYS AGO" : "DAYS FROM TODAY"

        return Text("\(abs(numberOfDaysFromTodayToSelectedDate)) \(daysDescription)")
            .font(.system(size: 10))
            .foregroundColor(.gray)
    }

}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        LightDarkThemePreview {
            MonthView(calendarManager: .mock, month: Date())

            MonthView(calendarManager: .mock, month: .daysFromToday(45))
        }
    }
}
