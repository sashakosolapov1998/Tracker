//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Косолапов on 31/5/25.
//
import Foundation

final class TrackerCategoryStore {
    private(set) var categories: [TrackerCategory] = []

    func add(_ tracker: Tracker, toCategoryWithTitle title: String) {
        if let index = categories.firstIndex(where: { $0.title == title }) {
            let oldCategory = categories[index]
            let updatedTrackers = oldCategory.trackers + [tracker]
            let updatedCategory = TrackerCategory(title: oldCategory.title, trackers: updatedTrackers)

            var updatedCategories = categories
            updatedCategories[index] = updatedCategory
            categories = updatedCategories
        } else {
            let newCategory = TrackerCategory(title: title, trackers: [tracker])
            categories.append(newCategory)
        }
    }
}
