//
//  Analitics.swift
//  Tracker
//
//  Created by Александр Косолапов on 27/7/25.
//


import Foundation
import AppMetricaCore

enum AnalyticsService {
    static func report(event: String, screen: String, item: String? = nil) {
        var parameters: [String: Any] = [
            "event": event,
            "screen": screen
        ]

        if let item = item {
            parameters["item"] = item
        }

        print("ANALYTICS EVENT: \(parameters)")

        AppMetrica.reportEvent(name: "ui_event", parameters: parameters) { error in
            print("REPORT ERROR: \(error.localizedDescription)")
        }
    }
}
