//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Александр Косолапов on 2/6/25.
import Foundation

final class TrackerRecordStore {
    private(set) var completedTrackers: [TrackerRecord] = []

    func add(_ record: TrackerRecord) {
        let updateRecords = completedTrackers + [record]
        completedTrackers = updateRecords
    }
    func remove(_ record: TrackerRecord) {
        let updatedRecords = completedTrackers.filter {
            !($0.trackerId == record.trackerId && Calendar.current.isDate($0.date, inSameDayAs: record.date))
        }
        completedTrackers = updatedRecords
    }
    func contains(_ record: TrackerRecord) -> Bool {
        return completedTrackers.contains {
            $0.trackerId == record.trackerId && Calendar.current.isDate($0.date, inSameDayAs: record.date)
        }
    }
}
