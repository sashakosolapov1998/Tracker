//
//  ColorCell.swift
//  Tracker
//
//  Created by Александр Косолапов on 26/6/25.
//



import UIKit

final class ColorCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorCell"

    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        backgroundColor = .white

        layer.borderWidth = isSelected ? 3 : 0
        layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : nil
        layer.cornerRadius = 8
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
