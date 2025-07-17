//
//   Weekday+Storage.swift
//  Tracker
//
//  Created by Александр Косолапов on 17/7/25.
//

extension Set<Tracker.Weekday> {
    func encode() -> String {
        let rawValues = self.map { String($0.rawValue) }
        return rawValues.joined(separator: ",")
    }

    static func decode(from string: String) -> Set<Tracker.Weekday> {
        let rawValues = string.split(separator: ",").compactMap { Int($0) }
        let weekdays = rawValues.compactMap { Tracker.Weekday(rawValue: $0) }
        return Set(weekdays)
    }
}
