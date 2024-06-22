//
//  File.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 20.06.2024.
//

import Foundation

struct ToDoItem {
    
    enum Importance: String {
        case unimportant = "Неважно"
        case regular = "Обычная"
        case important = "Важно"
    }
    
    let id: String
    let text: String
    let importance: Importance
    let createDate: Date
    let isComplete: Bool
    let changeDate: Date?
    let deadline: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .regular, 
        createDate: Date = Date(),
        isComplete: Bool = false,
        changeDate: Date? = nil,
        deadline: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.createDate = Date()
        self.isComplete = isComplete
        self.changeDate = changeDate
        self.deadline = deadline
    }
    
}


class FileCache {
    
    var ToDoItems: [String: ToDoItem] = [:]
    
    func addItem(newItem: ToDoItem) {
        ToDoItems[newItem.id] = newItem
    }
    
    func removeItem(by id: String) {
        ToDoItems.removeValue(forKey: id)
    }
    
    //__________________
    
    func jsonToString(from json: Any) -> String? {
        guard JSONSerialization.isValidJSONObject(json) else {
            print("Некорректный JSON")
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
            if let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
            print("Не удалось преобразовать Data в строку")
            return nil
        } catch {
            print("Ошибка")
            return nil
        }
    }

    ///____________________
    
    func saveData(to fileName: String) {
        
        // Массив строк, которые нужно сохранить в файл
        var jsonOfItems: [String] = []
        
        // Преобразуем каждый элемент ToDoItems в JSON строку
        for values in ToDoItems.values {
            if let jsonString = jsonToString(from: values.json) {
                jsonOfItems.append(jsonString)
            } else {
                print("Ошибка - Невозможно преобразовать элемент в JSON строку")
                return
            }
        }
        
        // Получаем URL текущей директории проекта
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        
        // Создаем URL для файла в папке проекта
        let filePath = (currentDirectoryPath as NSString).appendingPathComponent(fileName + ".json")
        
        // Используем URL для файла
        let fileURL = URL(fileURLWithPath: filePath)
        
        // Объединяем все JSON строки в один JSON массив
        let jsonArrayString = "[" + jsonOfItems.joined(separator: ",\n") + "]"
        print(jsonArrayString)
        
        // Преобразуем строку в данные
        guard let data = jsonArrayString.data(using: .utf8) else {
            print("Ошибка - Невозможно преобразовать JSON строку в данные.")
            return
        }
        
        do {
            // Получаем URL каталога Documents
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("data.json")
                try data.write(to: fileURL)
                print("Данные успешно записаны по пути: \(fileURL)")
            }
        } catch {
            print("Ошибка записи данных в файл: \(error)")
        }
        
    }
    
    
    func loadData() {
        
    }
    
}

// Класс FileCache
// Содержит закрытую для внешнего изменения, но открытую для получения коллекцию TodoItem
// Содержит функцию добавления новой задачи
// Содержит функцию удаления задачи (на основе id)
// Содержит функцию сохранения всех дел в файл
// Содержит функцию загрузки всех дел из файла
// Можем иметь несколько разных файлов
// Предусмотреть механизм защиты от дублирования задач (сравниванием id)
