//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Косолапов on 17/7/25.
//
import CoreData
import UIKit

final class TrackerStore: NSObject {
    static let shared = TrackerStore(context: CoreDataManager.shared.context)
    
    private let context: NSManagedObjectContext
    
    weak var delegate: TrackerStoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()
    
    // MARK: - Initialization
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func addTracker(_ tracker: Tracker, category: TrackerCategoryCoreData?) throws {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorHex = tracker.color.hexString
        trackerEntity.schedule = tracker.schedule.encode()
        
        var resolvedCategory = category
        if resolvedCategory == nil {
            let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "title == %@", "Без категории")
            if let existing = try? context.fetch(request).first {
                resolvedCategory = existing
            } else {
                let newCategory = TrackerCategoryCoreData(context: context)
                newCategory.title = "Без категории"
                resolvedCategory = newCategory
            }
        }
        trackerEntity.category = resolvedCategory
        try context.save()
    }
    
    func fetchTrackers() throws -> [Tracker] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let result = try context.fetch(request)
        return result.compactMap { entity in
            guard let id = entity.id,
                  let title = entity.title,
                  let emoji = entity.emoji,
                  let colorHex = entity.colorHex,
                  let scheduleString = entity.schedule else {
                return nil
            }
            
            return Tracker(
                id: id,
                title: title,
                color: UIColor.fromHex(colorHex),
                emoji: emoji,
                schedule: Set<Tracker.Weekday>.decode(from: scheduleString)
            )
        }
    }
    
    func deleteTracker(with id: UUID) throws {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let object = try context.fetch(request).first {
            context.delete(object)
            try context.save()
        }
    }
    
    func performFetch() throws {
        try fetchedResultsController.performFetch()
    }
    
    func numberOfTrackers() -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tracker(at index: Int) -> Tracker? {
        guard let entity = fetchedResultsController.fetchedObjects?[index],
              let id = entity.id,
              let title = entity.title,
              let emoji = entity.emoji,
              let colorHex = entity.colorHex,
              let scheduleString = entity.schedule else {
            return nil
        }
        
        return Tracker(
            id: id,
            title: title,
            color: UIColor.fromHex(colorHex),
            emoji: emoji,
            schedule: Set<Tracker.Weekday>.decode(from: scheduleString)
        )
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackers()
    }
}

// MARK: - TrackerStoreDelegate

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTrackers()
}
