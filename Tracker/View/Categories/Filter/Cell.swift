//
//  Cell.swift
//  Tracker
//
//  Created by Александр Косолапов on 25/7/25.
//


/* Устаревшая реализация. Не используется с переходом на StackView в FilterViewController
import UIKit

final class FilterCell: UITableViewCell {
    static let reuseIdentifier = "FilterCell"


    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let customSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupCheckmark()
        setupCustomSeparator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .ypWhite
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true

        contentView.addSubview(containerView)

        let stack = UIStackView(arrangedSubviews: [titleLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stack)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14)
        ])
    }

    private func setupCheckmark() {
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.image = UIImage(named: "checkmark")
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        checkmarkImageView.isHidden = true
    }

    private func setupCustomSeparator() {
        customSeparator.backgroundColor = .lightGray
        contentView.addSubview(customSeparator)

        NSLayoutConstraint.activate([
            customSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customSeparator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }

    func configure(with title: String, showCheckmark: Bool, isLastCell: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !showCheckmark
        customSeparator.isHidden = isLastCell
    }
}
*/
