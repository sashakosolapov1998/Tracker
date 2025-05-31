//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Александр Косолапов on 31/5/25.
//
import UIKit

extension UIColor {
    static var ypBackground: UIColor {
        UIColor(named: "Background") ?? .systemGray6
    }

    static var ypBlack: UIColor {
        UIColor(named: "Black") ?? .label
    }

    static var ypWhite: UIColor {
        UIColor(named: "White") ?? .white
    }

    static var ypRed: UIColor {
        UIColor(named: "Red") ?? .systemRed
    }

    static var ypBlue: UIColor {
        UIColor(named: "Blue") ?? .systemBlue
    }

    static var ypGray: UIColor {
        UIColor(named: "Gray") ?? .systemGray
    }

    static var ypLightGray: UIColor {
        UIColor(named: "Light Grey") ?? .systemGray4
    }
}
