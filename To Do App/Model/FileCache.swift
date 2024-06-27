//
//  FileCache.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.06.2024.
//

import Foundation



class FileCache: ObservableObject {
    
    @Published private(set) var todoItems: [String: TodoItem] = [:]
    
    func addItem(newItem: TodoItem) {
        todoItems[newItem.id] = newItem
    }
    
    func removeItem(by id: String) {
        todoItems.removeValue(forKey: id)
    }
    
    func saveItem(id: String, updatedItem: TodoItem) {
        todoItems[id] = updatedItem
    }
    
    func toggleComplete(for id: String) {
        if var item = todoItems[id] {
            item.isComplete.toggle()
            todoItems[id] = item
        }
    }
    
    //__________________
//    
//    func jsonToString(from json: Any) -> String? {
//        guard JSONSerialization.isValidJSONObject(json) else {
//            print("Некорректный JSON")
//            return nil
//        }
//
//        do {
//            let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
//            if let jsonString = String(data: data, encoding: .utf8) {
//                return jsonString
//            }
//            print("Не удалось преобразовать Data в строку")
//            return nil
//        } catch {
//            print("Ошибка")
//            return nil
//        }
//    }

    ///____________________
    
//    func saveData(to fileName: String) {
//        
//        // Массив строк, которые нужно сохранить в файл
//        var jsonOfItems: [String] = []
//        
//        // Преобразуем каждый элемент ToDoItems в JSON строку
//// Было бы здорово тут ToDoItems.values.reduce(into: []) { ... } использовать
//        for values in ToDoItems.values {
//            if let jsonString = jsonToString(from: values.json) {
//                jsonOfItems.append(jsonString)
//            } else {
//                print("Ошибка - Невозможно преобразовать элемент в JSON строку")
//                return
//            }
//        }
//        
//        // Получаем URL текущей директории проекта
//        let currentDirectoryPath = FileManager.default.currentDirectoryPath
//        
//        // Создаем URL для файла в папке проекта
//        let filePath = (currentDirectoryPath as NSString).appendingPathComponent(fileName + ".json")
//        
//        // Используем URL для файла
//        let fileURL = URL(fileURLWithPath: filePath)
//        
//        // Объединяем все JSON строки в один JSON массив
//        let jsonArrayString = "[" + jsonOfItems.joined(separator: ",\n") + "]"
//        print(jsonArrayString)
//        
//        // Преобразуем строку в данные
//        guard let data = jsonArrayString.data(using: .utf8) else {
//            print("Ошибка - Невозможно преобразовать JSON строку в данные.")
//            return
//        }
//        
//        do {
//            // Получаем URL каталога Documents
//            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                let fileURL = documentsDirectory.appendingPathComponent("data.json")
//                try data.write(to: fileURL)
//                print("Данные успешно записаны по пути: \(fileURL)")
//            }
//        } catch {
//            print("Ошибка записи данных в файл: \(error)")
//        }
//        
//    }
//    
//    func loadData() {
//        
//    }
    
}

