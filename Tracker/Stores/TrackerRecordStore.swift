//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Александр Косолапов on 17/7/25.
//
import CoreData

final class TrackerRecordStore {
    static let shared = TrackerRecordStore(context: CoreDataManager.shared.context)
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addRecord(_ record: TrackerRecord) throws {
        let recordEntity = TrackerRecordCoreData(context: context)
        recordEntity.date = record.date

        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.trackerId as CVarArg)

        if let tracker = try context.fetch(request).first {
            recordEntity.tracker = tracker
            try context.save()
        } else {
            throw NSError(domain: "Tracker not found", code: 404)
        }
    }

    func deleteRecord(trackerId: UUID, date: Date) throws {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date == %@",
            trackerId as CVarArg,
            date as CVarArg
        )

        if let record = try context.fetch(request).first {
            context.delete(record)
            try context.save()
        }
    }

    func fetchRecords() throws -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let result = try context.fetch(request)

        return result.compactMap { entity in
            guard let date = entity.date,
                  let trackerId = entity.tracker?.id else {
                return nil
            }

            return TrackerRecord(trackerId: trackerId, date: date)
        }
    }

}
