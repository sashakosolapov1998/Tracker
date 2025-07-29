//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Косолапов on 31/5/25.
//

import Foundation
import UIKit

struct Tracker: Equatable {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: Set<Weekday>
    
    enum Weekday : Int, CaseIterable, Hashable {
        case monday = 1
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
        
        var localizedName: String {
            switch self {
            case .monday: return NSLocalizedString("weekday_monday", comment: "")
            case .tuesday: return NSLocalizedString("weekday_tuesday", comment: "")
            case .wednesday: return NSLocalizedString("weekday_wednesday", comment: "")
            case .thursday: return NSLocalizedString("weekday_thursday", comment: "")
            case .friday: return NSLocalizedString("weekday_friday", comment: "")
            case .saturday: return NSLocalizedString("weekday_saturday", comment: "")
            case .sunday: return NSLocalizedString("weekday_sunday", comment: "")
            }
        }
    }
}
