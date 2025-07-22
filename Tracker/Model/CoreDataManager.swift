//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Александр Косолапов on 17/7/25.
//
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel") // Имя .xcdatamodeld
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка при загрузке хранилища: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
