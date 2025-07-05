//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 6/6/25.
//
import UIKit
import Foundation

// MARK: - NewHabitViewController
final class NewHabitViewController: UIViewController, ScheduleViewControllerDelegate {
    
    private let reuseIdentifier = "OptionCell"
    private let rowHeight: CGFloat = 75
    private let tableHeight: CGFloat = 150
    private let buttonHeight: CGFloat = 60
    // private let stackBottomPadding: CGFloat = 160
    private let stackSpacing: CGFloat = 24
    
    // MARK: - Properties
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func saveButtonTapped() {
        guard let title = trackerNameTextField.text, !title.isEmpty, !selectedDays.isEmpty else { return }

        guard let colorIndex = selectedColorIndex?.item,
              let emojiIndex = selectedEmojiIndex?.item else { return }

        let newTracker = Tracker(
            id: UUID(),
            title: title,
            color: TrackerConstants.colors[colorIndex],
            emoji: TrackerConstants.emojis[emojiIndex],
            schedule: selectedDays
        )
        
        delegate?.trackerWasCreated(newTracker)
        dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: TrackerCreationDelegate?
    private var selectedDays: Set<Tracker.Weekday> = []
    private var selectedEmojiIndex: IndexPath?
    private var selectedColorIndex: IndexPath?
    private let emojiTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let side = (UIScreen.main.bounds.width - 16*2 - 12*5) / 6
        layout.itemSize = CGSize(width: side, height: side)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let side = (UIScreen.main.bounds.width - 16*2 - 12*5) / 6
        layout.itemSize = CGSize(width: side, height: side)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let scrollView = UIScrollView()
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .ypBlack
        textField.font = .systemFont(ofSize: 17)
        textField.placeholder = "Введите название трекера"
        textField.textAlignment = .left
        
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .ypBackground
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitleNavBar()
        setupLayout()
        setupConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        setupButtons()
        trackerNameTextField.delegate = self
        trackerNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Setup
    private func setupButtons() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = stackSpacing
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupTitleNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        navigationItem.titleView = titleLabel
    }
    
    private func setupConstraints() {
        contentStackView.addArrangedSubview(trackerNameTextField)
        trackerNameTextField.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        contentStackView.addArrangedSubview(tableView)
        tableView.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
        contentStackView.addArrangedSubview(emojiTitleLabel)
        contentStackView.setCustomSpacing(12, after: emojiTitleLabel)
        contentStackView.addArrangedSubview(emojiCollectionView)
        emojiCollectionView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        contentStackView.addArrangedSubview(colorTitleLabel)
        contentStackView.setCustomSpacing(24, after: colorTitleLabel)
        contentStackView.addArrangedSubview(colorCollectionView)
        colorCollectionView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(saveButton)
        buttonStack.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        contentStackView.addArrangedSubview(buttonStack)
    }
    
    func scheduleViewController(_ viewController: ScheduleViewController, didSelectWeekdays weekdays: Set<Tracker.Weekday>) {
        self.selectedDays = weekdays
        updateSaveButtonState()
    }

    @objc private func textFieldDidChange() {
        updateSaveButtonState()
    }

    private func updateSaveButtonState() {
        let isTitleEmpty = trackerNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isDaysEmpty = selectedDays.isEmpty

        let shouldEnable = !isTitleEmpty && !isDaysEmpty
        saveButton.isEnabled = shouldEnable
        saveButton.backgroundColor = shouldEnable ? .ypBlack : .ypGray
    }
}

// MARK: - Extension
extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OptionCell
        cell.textLabel?.text = indexPath.row == 0 ? "Категория" : "Расписание"
        cell.showDivider(indexPath.row == 0)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let ScheduleVC = ScheduleViewController()
            let navController = UINavigationController(rootViewController: ScheduleVC)
            ScheduleVC.delegate = self
            present(navController, animated: true, completion: nil)
        } else {
            // TODO: Реализовать выбор категории
        }
    }
}
final class OptionCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
    }
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "YP Separator") ?? .lightGray
        return view
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }

    private func setupAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        layer.cornerRadius = 16
        layer.masksToBounds = true
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        accessoryType = .disclosureIndicator
        textLabel?.textAlignment = .left
        textLabel?.numberOfLines = 1
        textLabel?.baselineAdjustment = .alignCenters
        contentView.addSubview(divider)

        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5)
        ])

        divider.isHidden = true
    }
    
    func showDivider(_ show: Bool) {
        divider.isHidden = !show
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        divider.isHidden = true
    }
}

// MARK: - UITextFieldDelegate
extension NewHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Emoji CollectionView
extension NewHabitViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollectionView {
            return TrackerConstants.colors.count
        }
        return TrackerConstants.emojis.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else {
                return UICollectionViewCell()
            }
            let color = TrackerConstants.colors[indexPath.item]
            let isSelected = indexPath == selectedColorIndex
            cell.configure(with: color, isSelected: isSelected)
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
            return UICollectionViewCell()
        }
        let emoji = TrackerConstants.emojis[indexPath.item]
        let isSelected = indexPath == selectedEmojiIndex
        cell.configure(with: emoji, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollectionView {
            if let previousIndex = selectedColorIndex {
                if previousIndex == indexPath { return }
                if let previousCell = collectionView.cellForItem(at: previousIndex) as? ColorCell {
                    previousCell.configure(with: TrackerConstants.colors[previousIndex.item], isSelected: false)
                }
            }
            selectedColorIndex = indexPath
            if let currentCell = collectionView.cellForItem(at: indexPath) as? ColorCell {
                currentCell.configure(with: TrackerConstants.colors[indexPath.item], isSelected: true)
            }
        } else {
            if let previous = selectedEmojiIndex, let previousCell = collectionView.cellForItem(at: previous) as? EmojiCell {
                previousCell.configure(with: TrackerConstants.emojis[previous.item], isSelected: false)
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell {
                cell.configure(with: TrackerConstants.emojis[indexPath.item], isSelected: true)
            }
            selectedEmojiIndex = indexPath
        }
    }
}
