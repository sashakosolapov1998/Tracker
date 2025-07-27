//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Александр Косолапов on 17/7/25.
//
import CoreData

enum TrackerRecordStoreError: Error {
    case trackerNotFound
}

final class TrackerRecordStore {
    static let shared = TrackerRecordStore(context: CoreDataManager.shared.context)
    private let context: NSManagedObjectContext
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods

    func hasRecord(for trackerId: UUID, on date: Date) throws -> Bool {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date == %@",
            trackerId as CVarArg,
            date as CVarArg
        )

        let count = try context.count(for: request)
        return count > 0
    }
    func addRecord(_ record: TrackerRecord) throws {
        let recordEntity = TrackerRecordCoreData(context: context)
        recordEntity.date = record.date
        
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.trackerId as CVarArg)
        
        guard let tracker = try context.fetch(request).first else {
            throw TrackerRecordStoreError.trackerNotFound
        }
        recordEntity.tracker = tracker
        try context.save()
    }
    
    // MARK: - Public Methods
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
    
    // MARK: - Public Methods
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
