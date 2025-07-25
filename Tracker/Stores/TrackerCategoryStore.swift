//
//  Untitled.swift
//  Tracker
//
//  Created by Александр Косолапов on 17/7/25.
//
import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryStoreDidUpdate()
}

// MARK: - TrackerCategoryStore

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    weak var delegate: TrackerCategoryStoreDelegate?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addCategory(title: String) throws -> TrackerCategoryCoreData {
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        try context.save()
        delegate?.trackerCategoryStoreDidUpdate()
        return category
    }
    
    func fetchCategories() throws -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let result = try context.fetch(request)
        
        return result.compactMap { entity in
            guard let title = entity.title else {
                return nil
            }
            
            let trackerEntities = entity.trackers as? Set<TrackerCoreData> ?? []
            
            let trackers: [Tracker] = trackerEntities.compactMap { trackerEntity in
                guard let id = trackerEntity.id,
                      let title = trackerEntity.title,
                      let emoji = trackerEntity.emoji,
                      let colorHex = trackerEntity.colorHex,
                      let schedule = trackerEntity.schedule else {
                    return nil
                }
                
                return Tracker(
                    id: id,
                    title: title,
                    color: UIColor.fromHex(colorHex),
                    emoji: emoji,
                    schedule: Set<Tracker.Weekday>.decode(from: schedule)
                )
            }
            
            return TrackerCategory(title: title, trackers: trackers, coreData: entity)
        }
    }
}

// MARK: - Extensions

extension TrackerCategoryStore {
    func deleteTracker(_ tracker: Tracker) throws {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)

        guard let trackerEntity = try context.fetch(fetchRequest).first else {
            throw NSError(domain: "TrackerCategoryStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Tracker not found"])
        }

        context.delete(trackerEntity)
        try context.save()
        delegate?.trackerCategoryStoreDidUpdate()
    }
    func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        guard let categoryEntity = try context.fetch(request).first else {
            return
        }
        try addTracker(tracker, to: categoryEntity)
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) throws {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorHex = tracker.color.hexString
        trackerEntity.schedule = Set(tracker.schedule).encode()
        
        trackerEntity.category = category
        category.addToTrackers(trackerEntity)
        
        try context.save()
        delegate?.trackerCategoryStoreDidUpdate()
    }
    
    func deleteAllTrackers() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
        delegate?.trackerCategoryStoreDidUpdate()
    }
    
    func deleteAllCategories() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerCategoryCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
        delegate?.trackerCategoryStoreDidUpdate()
    }
}
