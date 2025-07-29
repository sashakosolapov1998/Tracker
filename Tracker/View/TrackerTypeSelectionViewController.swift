//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 6/6/25.
//
import UIKit

final class TrackerTypeSelectionViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: TrackerCreationDelegate?
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("habit", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapHabit), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("irregular_event", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapIrregular), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        navigationItem.title = NSLocalizedString("create_tracker", comment: "")
    }
    
    // MARK: - Layout
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
    
    private func presentInNavigation(_ viewController: UIViewController) {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }
    
    // MARK: - Actions
    @objc private func didTapHabit() {
        let newHabitVC = NewHabitViewController()
        newHabitVC.delegate = delegate
        presentInNavigation(newHabitVC)
    }
    
    @objc private func didTapIrregular() {
        let newIrregularVC = NewIrregularViewController()
        presentInNavigation(newIrregularVC)
    }
}
