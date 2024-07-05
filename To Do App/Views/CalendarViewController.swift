import UIKit
import SwiftUI

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
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
        tasksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
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
        
        for task in tasks {
            if let deadline = task.deadline {
                deadlines.append(deadline)
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
        
        for task in tasks {
            if let deadline = task.deadline {
                let sectionTitle = dateFormatter.string(from: deadline)
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
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let sectionTitle = sectionTitles[indexPath.section]
        let task: TodoItem
        
        if sectionTitle == "Другое" {
            task = noDeadlineTasks[indexPath.row]
        } else {
            task = groupedTasks[sectionTitle]?[indexPath.row] ?? TodoItem(id: UUID(), text: "Неизвестно", importance: .regular, createDate: Date(), isComplete: false, changeDate: nil, deadline: nil, color: nil)
        }
        
        cell.textLabel?.text = task.text
        cell.textLabel?.textColor = task.isComplete ? .gray : .black
        cell.textLabel?.attributedText = task.isComplete ? NSAttributedString(string: task.text, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]) : NSAttributedString(string: task.text, attributes: [:])
        
        return cell
    }
    
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
