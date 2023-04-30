import Foundation

/**
    A model returns time duration based on hours, minutes and seconds
 */
struct TimeDuration: Sizeable {
    var size: Double?

    /// A new instance initialized with `size`
    /// - Parameter size: TimeDuration size in 'Double'
    init(size: Double) {
        self.size = size
    }

    /// - Returns: Int
    /// - return time duration in seconds
    func seconds() -> Int {
        if let size = size {
            return Int(size.truncatingRemainder(dividingBy: 60))
        } else {
            return 0
        }
    }

    /// - Returns: Int
    /// - return time duration in minutes
    func minutes() -> Int {
        if let size = size {
            return Int(size / 60)
        } else {
            return 00
        }
    }

    // FIXME: Fix calculation
    /// - Returns: Int
    /// - return time duration in hours
    func hours() -> Int {
        if let size = size {
            return Int((size / 60) / 60)
        } else {
            return 00
        }
    }

    // FIXME: Fix calculation
    /// - Returns: String
    /// - return time duration in seconds as a String
    func secondsAsTwoDigitString() -> String {
        String(format: "%02d", seconds())
    }

    // FIXME: Fix calculation
    /// - Returns: String
    /// - return time duration in minutes as a String
    func minutesAsTwoDigitString() -> String {
        String(format: "%02d", minutes())

    }
    /// - Returns: String
    /// - return time duration in hours as a String
    func hoursAsTwoDigitString() -> String {
        String(format: "%02d", hours())
    }

    func getTimeAsHourMinuteSecond() -> String {
        "\(hoursAsTwoDigitString()):\(minutesAsTwoDigitString()):\(secondsAsTwoDigitString())"
    }
}
