//
//  Untitled.swift
//  Tracker
//
//  Created by Александр Косолапов on 17/7/25.
//
import CoreData
import UIKit

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addCategory(title: String) throws -> TrackerCategoryCoreData {
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        try context.save()
        return category
    }

    func fetchCategories() throws -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let result = try context.fetch(request)

        return result.compactMap { entity in
            guard let title = entity.title,
                  let trackerEntities = entity.trackers as? Set<TrackerCoreData> else {
                return nil
            }

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

            return TrackerCategory(title: title, trackers: trackers)
        }
    }
}
