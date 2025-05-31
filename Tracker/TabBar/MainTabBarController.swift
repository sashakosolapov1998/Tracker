//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Александр Косолапов on 25/5/25.
//
import UIKit
import Foundation

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupTabs()
    }
   
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        appearance.shadowColor = .separator
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupTabs() {
        let trackersVC = TrackersViewController()
        let navTrackers = UINavigationController(rootViewController: trackersVC)
        navTrackers.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers"),
            selectedImage: nil
        )
        
        let statisticsVS = StatisticsViewController()
        statisticsVS.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats"),
            selectedImage: nil
        )
        
        viewControllers = [navTrackers, statisticsVS]
    }
}
