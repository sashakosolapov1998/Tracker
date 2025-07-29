//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 27/7/25.
//

import UIKit
import AppMetricaCore

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
    private let emptyView = UIView()
    private let statsService = StatsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setupEmptyView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateStats),
            name: NSNotification.Name("StatsDidChange"),
            object: nil
        )
        tableView.isHidden = !hasStats()
        emptyView.isHidden = hasStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
    }
    
    @objc private func updateStats() {
        items = statsService.calculateStats()
        tableView.reloadData()
        tableView.isHidden = !hasStats()
        emptyView.isHidden = hasStats()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("StatsDidChange"), object: nil)
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
    
    private func setupEmptyView() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let imageView = UIImageView(image: UIImage(named: "nostat"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Анализировать пока нечего"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: emptyView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor)
        ])
    }
    
    private func hasStats() -> Bool {
        return !items.isEmpty && items.contains { $0.number > 0 }
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
