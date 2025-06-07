//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 7/6/25.
//

import UIKit
import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleViewController(_ vc: ScheduleViewController, didSelectWeekdays weekdays: Set<Tracker.Weekday>)
}

// MARK: - ScheduleViewController
final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedWeekdays: Set<Tracker.Weekday> = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(OptionCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .ypBackground
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitleNavBar()
        view.addSubview(doneButton)
        view.addSubview(tableView)
        setupConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

    }
    
   
    private func setupTitleNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Расписание"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        navigationItem.titleView = titleLabel
    }

    
    private func setupConstraints() {
        // Add fixed height constraint for tableView (7 rows * 75pt)
        tableView.heightAnchor.constraint(equalToConstant: 75 * 7).isActive = true
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            // tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -8), // Removed, tableView now has fixed height
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func doneButtonTapped() {
        delegate?.scheduleViewController(self, didSelectWeekdays: selectedWeekdays)
        dismiss(animated: true)
    }
}

// MARK: - Extension
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tracker.Weekday.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! OptionCell
       cell.textLabel?.text = String(describing: Tracker.Weekday.allCases[indexPath.row])
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.showDivider(indexPath.row != Tracker.Weekday.allCases.count - 1)
        let switchView = UISwitch()
        switchView.onTintColor = .systemBlue
        switchView.isOn = false
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        return cell
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let weekday = Tracker.Weekday.allCases[sender.tag]
        if sender.isOn {
            selectedWeekdays.insert(weekday)
        } else {
            selectedWeekdays.remove(weekday)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
