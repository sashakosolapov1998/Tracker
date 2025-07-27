import UIKit

final class CategoryCell: UITableViewCell {
    static let reuseIdentifier = "CategoryCell"

    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    let customSeparator = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(customSeparator)
        customSeparator.backgroundColor = .lightGray
        selectionStyle = .none

        backgroundColor = .ypBackground
        selectionStyle = .none

        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .ypBlack

        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = .blue
        checkmarkImageView.isHidden = true

        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        customSeparator.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        customSeparator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            customSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customSeparator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }

    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
    }

    func roundCorners(top: Bool, bottom: Bool) {
        let radius: CGFloat = 16
        layer.cornerRadius = radius
        layer.masksToBounds = true

        var corners: CACornerMask = []
        if top {
            corners.insert(.layerMinXMinYCorner)
            corners.insert(.layerMaxXMinYCorner)
        }
        if bottom {
            corners.insert(.layerMinXMaxYCorner)
            corners.insert(.layerMaxXMaxYCorner)
        }

        self.layer.maskedCorners = corners
        self.contentView.layer.cornerRadius = 0
    }
}
