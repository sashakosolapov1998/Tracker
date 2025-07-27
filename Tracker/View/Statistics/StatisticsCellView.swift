//
//  StatisticsCellView.swift
//  Tracker
//
//  Created by Александр Косолапов on 27/7/25.
//

import UIKit

final class StatisticsCellView: GradientBorderView {
    private let valueLabel = UILabel()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        borderWidth = 1
        cornerRadius = 16
        gradientColors = [
            UIColor.red,
            UIColor.green,
            UIColor.blue
        ]
        backgroundColor = .ypBackground

        valueLabel.font = .systemFont(ofSize: 34, weight: .bold)
        valueLabel.textAlignment = .left

        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textAlignment = .left

        addSubview(valueLabel)
        addSubview(titleLabel)

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    func configure(count: Int) {
        valueLabel.text = "\(count)"
    }
}
