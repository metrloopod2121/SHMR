//
//  MainViewModel.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 02.07.2024.
//

import Foundation

final class MainViewModel: ObservableObject {
    private var fileCache = FileCache()
    @Published var showButtonText = "Показать выполненное"
    @Published var sortButtonText = "Сортировать по важности"
    @Published var sortedItems: [TodoItem] = []
    @Published var count = 0
    
    func updateCount() {
        count = fileCache.todoItems.filter({ $0.value.isComplete == true }).count
    }
    
    func updateSortedItems() {
        sortedItems = showButtonText == "Показать выполненное" ? Array(fileCache.todoItems.values.filter({ $0.isComplete == false })) : Array(fileCache.todoItems.values)
        if sortButtonText == "Сортировать по добавлению" {
            sortedItems.sort(by: {$0.importance.getIndex() > $1.importance.getIndex()})
        } else {
            sortedItems.sort(by: {$0.createDate < $1.createDate})
        }
    }
    
    func changeShowButtonValue() {
        showButtonText = showButtonText == "Показать выполненное" ? "Скрыть выполненное" : "Показать выполненное"
    }
    
    func changeSortButtonValue() {
        sortButtonText = sortButtonText == "Сортировать по важности" ? "Сортировать по добавлению" : "Сортировать по важности"
    }
    
    func createItemWithAnotherIsDone(item: TodoItem) -> TodoItem {
        TodoItem(id: item.id, text: item.text, importance: item.importance, createDate: item.createDate, isComplete: !item.isComplete, changeDate: item.changeDate, deadline: item.deadline, color: item.color)
    }
    
    func createNewItem(item: TodoItem?, text: String, importance: Int, deadline: Date?, color: String?) -> TodoItem {
        if let item = item {
            return TodoItem(id: item.id, text: text, importance: Importance.allCases[importance], createDate: item.createDate, isComplete: false, changeDate: Date(), deadline: deadline, color: color)
        } else {
            return TodoItem(text: text, importance: Importance.allCases[importance], createDate: Date(), isComplete: false, changeDate: nil, deadline: deadline, color: color)
        }
    }
    
    func updateItem(item: TodoItem) {
        fileCache.addItem(item: item)
        saveItemsToJSON()
        prepare()
    }
    
    func deleteItem(id: UUID) {
        fileCache.removeItem(by: id)
        saveItemsToJSON()
        prepare()
    }
    
    func loadItemsFromJSON() throws {
        try fileCache.getItemsFromJSON(fileName: "data1")
        prepare()
    }
    
    func saveItemsToJSON() {
        do {
            try fileCache.saveJSON(fileName: "data1")
        } catch {
            print("Ошибка при сохранении данных в JSON: \(error)")
        }
    }
    
    func prepare() {
        updateSortedItems()
        updateCount()
    }
    
}
