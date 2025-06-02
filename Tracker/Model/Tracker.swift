//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Косолапов on 31/5/25.
//

import Foundation
import UIKit

struct Tracker {
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
    }
}
