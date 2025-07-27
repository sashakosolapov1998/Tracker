//
//  GradientBorderView.swift
//  Tracker
//
//  Created by Александр Косолапов on 27/7/25.
//


import UIKit

class GradientBorderView: UIView {
    
    var gradientColors: [UIColor] = [] {
        didSet {
            updateGradient()
        }
    }
    
    var borderWidth: CGFloat = 1 {
        didSet {
            updateMask()
        }
    }
    
    var cornerRadius: CGFloat = 16 {
        didSet {
            updateMask()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateMask()
    }
    
    private func updateGradient() {
        gradientLayer.colors = gradientColors.map { $0.cgColor }
    }
    
    private func updateMask() {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2), cornerRadius: cornerRadius)
        maskLayer.path = path.cgPath
        maskLayer.lineWidth = borderWidth
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
    }
}
