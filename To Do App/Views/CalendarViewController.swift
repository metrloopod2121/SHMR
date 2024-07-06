import UIKit
import SwiftUI

// TaskTableViewCell.swift
class TaskTableViewCell: UITableViewCell {

    let taskLabel = UILabel()
    let circleView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Настраиваем метку задачи
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskLabel)

        // Настраиваем кружок
        circleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(circleView)

        // Задаем параметры круга
        circleView.layer.cornerRadius = 10
        circleView.layer.masksToBounds = true

        // Настраиваем констрейнты для метки задачи
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // Настраиваем констрейнты для кружка
            circleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 20),
            circleView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(task: TodoItem) {
        // Настраиваем текст метки
        taskLabel.text = task.text
        
        var whatColor: UIColor
        if task.category == .hobby {
            whatColor = .green
        } else if task.category == .work {
            whatColor = .red
        } else if task.category == .study {
            whatColor = .blue
        } else {
            whatColor = .clear
        }

        // Задаем цвет круга
        circleView.backgroundColor = whatColor
    }
}

// CalendarViewController.swift
class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    private let calendarCollectionView: UICollectionView
    let tasksTableView = UITableView()

    private var deadlines: [Date] = []

    private var groupedTasks: [String: [TodoItem]] = [:]
    private var noDeadlineTasks: [TodoItem] = []
    private var sectionTitles: [String] = []

    var tasks: [TodoItem] = [] {
        didSet {
            updateDeadlines()
            groupTasksByDeadline()
        }
    }

    private var isScrollingCalendar = false
    private var isScrollingTasks = false

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 60, height: 80)
        
        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        calendarCollectionView.showsHorizontalScrollIndicator = false
        
        super.init(nibName: nil, bundle: nil)
        
        calendarCollectionView.backgroundColor = .white
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        
        updateDeadlines()
        groupTasksByDeadline()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(calendarCollectionView)
        view.addSubview(tasksTableView)
        
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor, constant: 20),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func updateDeadlines() {
        deadlines.removeAll()
        
        let calendar = Calendar.current
        
        for task in tasks {
            if let deadline = task.deadline {
                let startOfDayDeadline = calendar.startOfDay(for: deadline)
                if !deadlines.contains(startOfDayDeadline) {
                    deadlines.append(startOfDayDeadline)
                }
            }
        }
        
        deadlines.sort()
        
        calendarCollectionView.reloadData()
    }

    private func groupTasksByDeadline() {
        groupedTasks.removeAll()
        noDeadlineTasks.removeAll()
        sectionTitles.removeAll()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        let calendar = Calendar.current
        
        for task in tasks {
            if let deadline = task.deadline {
                let startOfDayDeadline = calendar.startOfDay(for: deadline)
                let sectionTitle = dateFormatter.string(from: startOfDayDeadline)
                if groupedTasks[sectionTitle] == nil {
                    groupedTasks[sectionTitle] = []
                }
                groupedTasks[sectionTitle]?.append(task)
            } else {
                noDeadlineTasks.append(task)
            }
        }
        
        sectionTitles = groupedTasks.keys.sorted { dateFormatter.date(from: $0)! < dateFormatter.date(from: $1)! }
        
        if !noDeadlineTasks.isEmpty {
            sectionTitles.append("Другое")
        }
        
        tasksTableView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deadlines.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        cell.backgroundColor = .systemBlue
        
        let deadline = deadlines[indexPath.item]
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: deadline)
        let month = calendar.monthSymbols[calendar.component(.month, from: deadline) - 1]
        
        cell.dayLabel.text = "\(day)"
        cell.monthLabel.text = month
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }

    // Обработка нажатий на ячейку календаря
    @objc private func handleCellTap(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? DayCell, let indexPath = calendarCollectionView.indexPath(for: cell) else { return }
        
        let deadline = deadlines[indexPath.item]
        
        scrollToSection(for: deadline)
    }

    // Скроллинг до секции с задачами, имеющими дедлайн
    private func scrollToSection(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let sectionTitle = dateFormatter.string(from: date)
        
        if let sectionIndex = sectionTitles.firstIndex(of: sectionTitle) {
            tasksTableView.scrollToRow(at: IndexPath(row: 0, section: sectionIndex), at: .top, animated: true)
        }
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == calendarCollectionView {
            guard !isScrollingTasks else { return }
            isScrollingCalendar = true
            syncTasksWithCalendarScroll()
            isScrollingCalendar = false
        } else if scrollView == tasksTableView {
            guard !isScrollingCalendar else { return }
            isScrollingTasks = true
            syncCalendarWithTasksScroll()
            isScrollingTasks = false
        }
    }

    private func syncTasksWithCalendarScroll() {
        // Найдем ближайшую видимую ячейку календаря
        let visibleCells = calendarCollectionView.indexPathsForVisibleItems
        guard let firstVisibleCellIndexPath = visibleCells.sorted().first else { return }
        
        let deadline = deadlines[firstVisibleCellIndexPath.item]
        scrollToSection(for: deadline)
    }

    private func syncCalendarWithTasksScroll() {
        // Найдем ближайшую видимую секцию в списке задач
        guard let firstVisibleIndexPath = tasksTableView.indexPathsForVisibleRows?.first else { return }
        
        let sectionTitle = sectionTitles[firstVisibleIndexPath.section]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        if let date = dateFormatter.date(from: sectionTitle) {
            scrollToCalendarCell(for: date)
        }
    }

    private func scrollToCalendarCell(for date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        if let index = deadlines.firstIndex(of: startOfDay) {
            calendarCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        if sectionTitle == "Другое" {
            return noDeadlineTasks.count
        }
        return groupedTasks[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        let sectionTitle = sectionTitles[indexPath.section]
        let task: TodoItem
        
        if sectionTitle == "Другое" {
            task = noDeadlineTasks[indexPath.row]
        } else {
            task = groupedTasks[sectionTitle]?[indexPath.row] ?? TodoItem(id: UUID(), text: "Неизвестно", importance: .regular, createDate: Date(), isComplete: false, changeDate: nil, deadline: nil, color: nil)
        }
        
        cell.configure(task: task)
        
        return cell
    }

    // MARK: - Swipe Actions

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let sectionTitle = self.sectionTitles[indexPath.section]
            if sectionTitle == "Другое" {
                self.noDeadlineTasks[indexPath.row].isComplete = true
            } else {
                self.groupedTasks[sectionTitle]?[indexPath.row].isComplete = true
            }
            self.tasksTableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        completeAction.backgroundColor = .green
        completeAction.image = UIImage(systemName: "checkmark.circle.fill")
        return UISwipeActionsConfiguration(actions: [completeAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uncompleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let sectionTitle = self.sectionTitles[indexPath.section]
            if sectionTitle == "Другое" {
                self.noDeadlineTasks[indexPath.row].isComplete = false
            } else {
                self.groupedTasks[sectionTitle]?[indexPath.row].isComplete = false
            }
            self.tasksTableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        uncompleteAction.backgroundColor = .gray
        uncompleteAction.image = UIImage(systemName: "circle")
        return UISwipeActionsConfiguration(actions: [uncompleteAction])
    }
}
