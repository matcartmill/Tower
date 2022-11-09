import Foundation

public struct CalendarDataSource: Equatable {
    public struct Header: Equatable {
        public let days: [String]
        
        public init(days: [String]) {
            self.days = days
        }
    }
    public struct Row: Equatable, Identifiable {
        public enum Value: Equatable {
            case actual(Int, current: Bool)
            case empty
        }
        
        public let id = UUID().uuidString
        public var dates: [Value]
    }
    
    public let header: Header
    public let rows: [Row]
    
    public init(header: Header, rows: [Row]) {
        self.header = header
        self.rows = rows
    }
    
    public init(calendar: Calendar = .autoupdatingCurrent, currentDate: Date = .init()) {
        func buildRows(offset: Int, range: Range<Int>, numberOfDaysInWeek: Int) -> [Row] {
            var rows: [Row] = []
            var arr = [Int](range.min()!...range.max()!)
            
            while !arr.isEmpty {
                if rows.isEmpty {
                    rows.append(.init(dates: []))
                    let range = arr[0..<(numberOfDaysInWeek - offset)]
                    range.forEach { rows[0].dates.append(.actual($0, current: $0 == currentDay.day!)) }
                    arr.removeFirst(range.count)
                    
                    for _ in 0..<offset { rows[0].dates.insert(.empty, at: 0) }
                } else {
                    let minimum = min(numberOfDaysInWeek, arr.count)
                    let range = arr[0..<minimum]
                    let values: [Row.Value] = range.map { .actual($0, current: $0 == currentDay.day!) }
                    
                    rows.append(.init(dates: values))
                    arr.removeFirst(range.count)
                    
                    let remainder = numberOfDaysInWeek - range.count
                    
                    if remainder > 0 {
                        for _ in 0..<remainder { rows[rows.count - 1].dates.append(.empty) }
                    }
                }
            }
            
            return rows
        }
        
        let currentDay = calendar.dateComponents([.day], from: currentDate)
        let daysOfTheMonth = calendar.range(of: .day, in: .month, for: currentDate)
        let currentMonth = calendar.dateComponents([.year, .month], from: currentDate)
        let firstDayOfTheMonth = calendar.date(from: currentMonth)!
        let firstWeekday = calendar.dateComponents([.weekday], from: firstDayOfTheMonth)
        let offset = firstWeekday.weekday! - 1
        
        self.header = .init(days: calendar.veryShortWeekdaySymbols)
        self.rows = buildRows(
            offset: offset,
            range: daysOfTheMonth!,
            numberOfDaysInWeek: calendar.veryShortWeekdaySymbols.count
        )
    }
}
