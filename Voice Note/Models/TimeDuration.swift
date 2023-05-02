import Foundation

/**
    A model that holds duration of time
 */
struct TimeDuration: Sizeable {
    var size: Double?

    /// A new instance initialized with `size`
    /// - Parameter size: TimeDuration size in 'Double'
    init(size: Double) {
        self.size = size
    }

    /// Return duration in seconds
    /// - Returns: Int
    func seconds() -> Int {
        if let size = size {
            return Int(size.truncatingRemainder(dividingBy: 60))
        } else {
            return 0
        }
    }

    /// Return duration in minutes
    /// - Returns: Int
    func minutes() -> Int {
        if let size = size {
            return Int(size / 60)
        } else {
            return 00
        }
    }

    /// Return duration in hours
    /// - Returns: Int
    func hours() -> Int {
        if let size = size {
            return Int((size / 60) / 60)
        } else {
            return 00
        }
    }

    /// Return two digit String representation of second
    /// - Returns: String
    func secondsAsTwoDigitString() -> String {
        String(format: "%02d", seconds())
    }

    /// Return two digit String representation of minutes
    /// - Returns: String
    func minutesAsTwoDigitString() -> String {
        String(format: "%02d", minutes())

    }

    /// Return two digit String representation of hours
    /// - Returns: String
    func hoursAsTwoDigitString() -> String {
        String(format: "%02d", hours())
    }

    /// Return String representation of time duration in HH:MM:SS formate
    /// - Returns: String
    func getTimeAsHourMinuteSecond() -> String {
        "\(hoursAsTwoDigitString()):\(minutesAsTwoDigitString()):\(secondsAsTwoDigitString())"
    }
}
