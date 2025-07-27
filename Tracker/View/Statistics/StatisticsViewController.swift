//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 27/7/25.
//

import UIKit

struct StatItem {
    let number: Int
    let title: String
}

final class StatisticsViewController: UIViewController {
    private let tableView = UITableView()
    private var items: [StatItem] = [
        StatItem(number: 0, title: "Лучший период"),
        StatItem(number: 0, title: "Идеальные дни"),
        StatItem(number: 0, title: "Завершено"),
        StatItem(number: 0, title: "Среднее значение")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false

        title = NSLocalizedString("tabbar_statistics_title", comment: "")
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(StatCell.self, forCellReuseIdentifier: "StatCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as? StatCell else {
            return UITableViewCell()
        }
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
}
