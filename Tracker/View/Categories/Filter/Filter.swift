//
//  Filter.swift
//  Tracker
//
//  Created by Александр Косолапов on 25/7/25.
//

enum TrackerFilter: CaseIterable {
    case all
    case today
    case completed
    case notCompleted
    
    var title: String {
        switch self {
        case .all:
            return "Все трекеры"
        case .today:
            return "Трекеры на сегодня"
        case .completed:
            return "Завершённые"
        case .notCompleted:
            return "Незавершённые"
        }
    }
    
    var isCustomFilter: Bool {
        switch self {
        case .completed, .notCompleted:
            return true
        default:
            return false
        }
    }
    
    static var `default`: TrackerFilter {
        return .all
    }
}
