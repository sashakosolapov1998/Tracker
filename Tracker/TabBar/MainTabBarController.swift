//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Александр Косолапов on 25/5/25.
//
import UIKit
import Foundation

// MARK: - MainTabBarController
final class MainTabBarController: UITabBarController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupTabs()
    }
   
    // MARK: - Private Methods
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
        
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats"),
            selectedImage: nil
        )
        
        viewControllers = [navTrackers, statisticsVC]
    }
}
