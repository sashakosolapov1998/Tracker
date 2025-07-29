//
//  TrackerSectionHeaderView.swift
//  Tracker
//
//  Created by Александр Косолапов on 4/6/25.
//
import UIKit

final class TrackerSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "TrackerSectionHeaderView"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
