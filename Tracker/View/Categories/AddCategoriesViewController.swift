//
//  AddCategories.swift
//  Tracker
//
//  Created by Александр Косолапов on 22/7/25.
//

import UIKit

final class AddCategoriesViewController: UIViewController {
    private let store: TrackerCategoryStore
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let readyButton = UIButton()
    
    init(store: TrackerCategoryStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addSubviews()
        setupConstraints()
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = NSLocalizedString("new_category_title", comment: "")
        
        titleLabel.text = NSLocalizedString("category_name_title", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .ypBlack
        
        textField.borderStyle = .none
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.placeholder = NSLocalizedString("category_name_placeholder", comment: "")
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        
        readyButton.setTitle(NSLocalizedString("done_button_title", comment: ""), for: .normal)
        readyButton.backgroundColor = .gray
        readyButton.setTitleColor(.white, for: .normal)
        readyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        readyButton.layer.cornerRadius = 16
        readyButton.isEnabled = false
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(readyButton)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func textFieldDidChange() {
        let isValid = !(textField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        readyButton.isEnabled = isValid
        readyButton.backgroundColor = isValid ? .ypBlack : .gray
    }
    
    @objc private func readyButtonTapped() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else { return }
        
        print("Добавление категории: \(text)")
        try? store.addCategory(title: text)
        textField.resignFirstResponder()
        dismiss(animated: true)
    }
}

extension AddCategoriesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
