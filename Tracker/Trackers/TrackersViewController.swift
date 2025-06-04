//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 25/5/25.
//
import UIKit

final class TrackersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
     
    // MARK: - Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    // тестируем временно трекеры
    var trackerCategoryStore = TrackerCategoryStore()
    let trackerTest1 = Tracker (id: UUID(), title:"Прогулка на свежем воздухе", color: .colorSelection1, emoji: "🚶", schedule: [.monday, .wednesday, .friday])
    let trackerTest2 = Tracker (id: UUID(), title:"Позвонить бубушке", color: .colorSelection5, emoji: "💁🏻", schedule: [.saturday, .friday])
    let trackerTest3 = Tracker (id: UUID(), title:"Хуйня какая то", color: .colorSelection7, emoji: "🙈", schedule: [.saturday, .friday])
    let trackerTest4 = Tracker (id: UUID(), title:"Проверяем это все на работу", color: .colorSelection2, emoji: "❤️", schedule: [.saturday, .friday])
    
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nothing")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell") // потом заменим на кастомную ячейку
        collectionView.register(
            TrackerSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier
        )
        
        
        // тест
        trackerCategoryStore.add(trackerTest1, toCategoryWithTitle: "Радостные мелочи")
        trackerCategoryStore.add(trackerTest2, toCategoryWithTitle: "Важные дела")
        
        trackerCategoryStore.add(trackerTest3, toCategoryWithTitle: "Радостные мелочи")
        trackerCategoryStore.add(trackerTest4, toCategoryWithTitle: "Радостные мелочи")
        
        categories = trackerCategoryStore.categories
        collectionView.reloadData()
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        setupNavigationBar()
       // setupEmptyPlaceholder()  сделаем потом метод для проверки, есть ли трекеры
    }
    
    // MARK: - Setup UI
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
            style: .plain,
            target: self,
            action: #selector(didTapAdd)
        )
        addButton.tintColor = .ypBlack
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    // MARK: - Actions
    @objc private func didTapAdd() {
        // потом реализуем
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        // Здесь должен быть вызов фильтрации трекеров по дню недели
    }
    
    private func setupEmptyPlaceholder() {
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8)
        ])
    }
    
    //MARK: - UICollectionView
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerSectionHeaderView else {
            return UICollectionReusableView()
        }

        header.titleLabel.text = categories[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Получаем трекер из текущей категории и позиции
        let tracker = categories[indexPath.section].trackers[indexPath.item]

        // Получаем ячейку и кастуем к нужному типу
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }

        // Настраиваем внешний вид ячейки
        cell.emojiLabel.text = tracker.emoji
        cell.titleLabel.text = tracker.title
        cell.backgroundColor = .clear // чтобы фон не перекрывал закруглённую карту
        cell.cardView.backgroundColor = tracker.color

        // Счётчик дней — пока просто 0 дней, позже будет логика подсчёта
        cell.daysLabel.text = "0 дней"

        return cell
    }
    
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // тут твой расчёт
        let insets = collectionViewFlowLayout.sectionInset
        let spacing = collectionViewFlowLayout.minimumInteritemSpacing
        let availableWidth = collectionView.bounds.width - insets.left - insets.right - spacing
        let itemWidth = floor(availableWidth / 2)
        let itemHeight: CGFloat = 148
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}
