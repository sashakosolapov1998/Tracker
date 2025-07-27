//
//  FilterViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 25/7/25.
//



import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func filterViewController(_ controller: FilterViewController, didSelect filter: TrackerFilter)
}

final class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?
    
    private let filters = TrackerFilter.allCases
    private var selectedFilter: TrackerFilter
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let filterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var filterButtonMap: [UIButton: TrackerFilter] = [:]
    
    init(selectedFilter: TrackerFilter = .default) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(filterContainerView)
        filterContainerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filterContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            filterContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: filterContainerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: filterContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: filterContainerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: filterContainerView.bottomAnchor)
        ])
        
        for (index, filter) in filters.enumerated() {
            let button = createFilterButton(for: filter)
            stackView.addArrangedSubview(button)
            
            // Добавляем разделитель, кроме последнего
            if index < filters.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor.lightGray
                separator.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(separator)
                NSLayoutConstraint.activate([
                    separator.heightAnchor.constraint(equalToConstant: 1),
                    separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
                    separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
                ])
            }
        }
    }
    
    private func createFilterButton(for filter: TrackerFilter) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(filter.title, for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        filterButtonMap[button] = filter
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let filter = filterButtonMap[sender] else { return }
        delegate?.filterViewController(self, didSelect: filter)
        dismiss(animated: true)
    }
}

