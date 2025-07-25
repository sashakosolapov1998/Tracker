//  TrackerTest.swift
//  Tracker
//
//  Created by Александр Косолапов on 25/7/25.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = true
    }

    func testViewControllerLight() {
        let trackersViewController = TrackersViewController()
        let navTrackersViewController = UINavigationController(rootViewController: trackersViewController)
        assertSnapshot(matching: navTrackersViewController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

    func testViewControllerDark() {
        let trackersViewController = TrackersViewController()
        let navTrackersViewController = UINavigationController(rootViewController: trackersViewController)
        assertSnapshot(matching: navTrackersViewController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
