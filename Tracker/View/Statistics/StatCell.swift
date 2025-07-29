
//
//  StatCell.swift
//  Tracker
//
//  Created by Александр Косолапов on 27/7/25.
//

import UIKit

final class StatCell: UITableViewCell {
    private let statView = StatisticsCellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(statView)
        statView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            statView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            statView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with item: StatItem) {
        statView.configure(count: item.number)
        statView.titleLabel.text = item.title
    }
}

