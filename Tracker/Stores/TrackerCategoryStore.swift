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

        print("🔍 Всего категорий в CoreData: \(result.count)")

        return result.compactMap { entity in
            guard let title = entity.title else {
                return nil
            }

            print("📦 Категория: \(title)")

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

            print("📦 Трекеров в категории: \(trackers.count)")

            return TrackerCategory(title: title, trackers: trackers, coreData: entity)
        }
    }
}

extension TrackerCategoryStore {
    func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        print("Ищем категорию с названием: \(title)")

        guard let categoryEntity = try context.fetch(request).first else {
            print("Категория с названием \(title) не найдена.")
            return
        }
        print("Найдена категория в CoreData: \(categoryEntity.title ?? "без названия")")

        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorHex = tracker.color.hexString
        trackerEntity.schedule = Set(tracker.schedule).encode()

        trackerEntity.category = categoryEntity
        categoryEntity.addToTrackers(trackerEntity)
        
        try context.save()
        delegate?.trackerCategoryStoreDidUpdate()
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
