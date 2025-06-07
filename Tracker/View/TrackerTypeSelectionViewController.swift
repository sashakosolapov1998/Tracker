//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 6/6/25.
//
import UIKit

final class TrackerTypeSelectionViewController: UIViewController {
    weak var delegate: TrackerCreationDelegate?
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapHabit), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapIrregular), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupTitleNavBar()
    }

    private func setupTitleNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Создание трекера"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        navigationItem.titleView = titleLabel
    }
    
    private func setupLayout() {
        let buttonStack = UIStackView(arrangedSubviews: [habitButton, irregularButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 16
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func didTapHabit() {
        let newHabitVC = NewHabitViewController()
        newHabitVC.delegate = delegate
        let navVC = UINavigationController(rootViewController: newHabitVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }

    @objc private func didTapIrregular() {
        let newIrregularVC = NewIrregularViewController()
        let navVC = UINavigationController(rootViewController: newIrregularVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }
}
