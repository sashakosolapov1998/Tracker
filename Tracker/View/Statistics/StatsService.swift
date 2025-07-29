//
//  StatsService.swift
//  Tracker
//
//  Created by Александр Косолапов on 27/7/25.
//
import Foundation

final class StatsService {
    private let trackerRecordStore = TrackerRecordStore(context: CoreDataManager.shared.context)
    
    func calculateStats() -> [StatItem] {
        do {
            let records = try trackerRecordStore.fetchRecords()
            
            let totalCompleted = records.count
            let bestStreak = 0
            let perfectDays = 0
            let average = 0
            
            return [
                //StatItem(number: bestStreak, title: "Лучший период"),
                //StatItem(number: perfectDays, title: "Идеальные дни"),
                StatItem(number: totalCompleted, title: "Завершено"),
                //StatItem(number: average, title: "Среднее значение")
            ]
        } catch {
            print("Ошибка получения статистики: \(error)")
            return []
        }
    }
}
