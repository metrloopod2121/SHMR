//
//  ParsingJSON.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 20.06.2024.
//
//Расширение для структуры TodoItem
//Содержит функцию (static func parse(json: Any) -> TodoItem?) для разбора json
//Содержит вычислимое свойство (var json: Any) для формирования json’а
//Не сохранять в json важность, если она «обычная»
//Не сохранять в json сложные объекты (Date)
//Сохранять deadline только если он задан
//Обязательно использовать JSONSerialization (т.е. работу со словарем)

import Foundation

extension ToDoItem {
    
    static func parse(json: Any) -> ToDoItem? {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let isComplete = dictionary["isComplete"] as? Bool,
              let changeDate = dictionary["changeDate"] as? Date,
              let deadline = dictionary["deadline"] as? Date,
              let createDate = dictionary["createDate"] as? Date else {
            return nil
        }
            
        var importance: Importance = .unimportant
        if let importanceString = dictionary["importance"] as? String {
            importance = Importance(rawValue: importanceString) ?? .unimportant
        }
    
            
        return ToDoItem(
            id: id,
            text: text,
            importance: importance,
            createDate: createDate,
            isComplete: isComplete,
            changeDate: changeDate,
            deadline: deadline
        )
    }
    
    
    var json: Any {
        var jsonDictionary: [String: Any] = [
            "id": self.id,
            "text": self.text,
            "isComplete": self.isComplete,
            "createDate": self.createDate,
            "deadline": self.deadline ?? createDate,
            "changeDate": self.changeDate ?? createDate
        ]
        
        if self.importance != .regular {
            jsonDictionary["importance"] = self.importance.rawValue
        }
    
        return jsonDictionary
    }
    
    // let jsonString = "{\"location\": \"the moon\"}"
}
        

    
