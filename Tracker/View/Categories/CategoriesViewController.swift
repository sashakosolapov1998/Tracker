//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 22/7/25.
//


import UIKit

final class CategoriesViewController: UIViewController {
    private let viewModel: CategoriesViewModel
    private let tableView = UITableView()
    private let addCategoryButton = UIButton()
    
    var onCategorySelected: ((TrackerCategoryCoreData) -> Void)?
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //удаляем категории для теста
        //try? viewModel.categoryStore.deleteAllCategories()
        
        setup()
        addSubviews()
        setupConstraints()
        setupBindings()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        
        viewModel.fetchCategories()
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = NSLocalizedString("category_title", comment: "")
        
        tableView.separatorStyle = .none
        
        addCategoryButton.backgroundColor = .ypBlack
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.setTitle(NSLocalizedString("add_category_button", comment: ""), for: .normal)
        addCategoryButton.setTitleColor(.white, for: .normal)
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupBindings() {
        viewModel.onCategoriesChanged = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updatePlaceholder(isEmpty: self.viewModel.isEmpty)
        }
        
        viewModel.onCategorySelected = { [weak self] selectedCategoryCoreData in
            self?.onCategorySelected?(selectedCategoryCoreData.coreData)
        }
    }
    
    @objc private func addButtonTapped() {
        let addVC = AddCategoriesViewController(store: viewModel.categoryStore)
        let navVC = UINavigationController(rootViewController: addVC)
        present(navVC, animated: true)
    }
    
    private func updatePlaceholder(isEmpty: Bool) {
        if isEmpty {
            let placeholderView = UIView()
            
            let imageView = UIImageView(image: UIImage(named: "nothing"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 80)
            ])
            
            let label = UILabel()
            label.text = NSLocalizedString("categories_placeholder", comment: "")
            label.textColor = .ypBlack
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.textAlignment = .center
            label.numberOfLines = 2
            
            let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.axis = .vertical
            stackView.spacing = 16
            stackView.alignment = .center
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            placeholderView.addSubview(stackView)
            placeholderView.frame = tableView.bounds
            
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor, constant: 32),
                stackView.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor, constant: -32)
            ])
            
            tableView.backgroundView = placeholderView
        } else {
            tableView.backgroundView = nil
        }
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let category = viewModel.category(at: indexPath.row)
        let isSelected = viewModel.isSelected(at: indexPath.row)
        cell.configure(with: category.title, isSelected: isSelected)
        
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == viewModel.numberOfCategories - 1
        cell.roundCorners(top: isFirst, bottom: isLast)
        cell.customSeparator.isHidden = isLast
        
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = viewModel.category(at: indexPath.row)
        self.onCategorySelected?(selectedCategory.coreData)
        dismiss(animated: true)
    }
}
