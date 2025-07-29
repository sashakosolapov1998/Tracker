//  TrackerSnapshotTests.swift
//  TrackerSnapshotTests
//
//  Created by Александр Косолапов on 30/7/25.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = false //эталон
    }

    func testMainScreenSnapshot() {
        let vc = TrackersViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844) // iPhone 14
        navVC.beginAppearanceTransition(true, animated: false)
        navVC.endAppearanceTransition()
        assertSnapshot(matching: navVC, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
}
