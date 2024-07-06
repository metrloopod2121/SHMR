//
//  FileCache.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.06.2024.
//

import Foundation



class FileCache: ObservableObject {
    
    private(set) var todoItems: [UUID: TodoItem] = [:]
    
    
    var countOfCompletedTasks: Int {
        return todoItems.values.filter { $0.isComplete }.count
    }
    
    func addItem(item: TodoItem) {
        todoItems[item.id] = item
    }
    
    func removeItem(by id: UUID) {
        todoItems[id] = nil
    }
    
//    func toggleComplete(for id: String) {
//        if var item = todoItems[id] {
//            item.isComplete.toggle()
//            todoItems[id] = item
//        }
//    }
    
    func saveJSON(fileName: String) throws {
        let jsonData = todoItems.values.map(\.json)
        let encodedData = try JSONSerialization.data(withJSONObject: jsonData, options: [.prettyPrinted, .sortedKeys])
        try saveToJSONFile(fileName: "\(fileName).json", jsonData: encodedData)
    }
    
    func saveCSV(fileName: String) throws {
        let csvData = [TodoItem.csvTitles] + todoItems.values.map(\.csv)
        guard let csvData = csvData as? [String] else { return }
        let csvString = csvData.joined(separator: TodoItem.csvRowsDelimiter)
        try saveToCSVFile(fileName: "\(fileName).csv", csvString: csvString)
    }
    
    func getItemsFromJSON(fileName: String) throws {
        let jsonData = try getFromJSONFile(fileName: "\(fileName).json")
        let decodedData = try JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let newItems = decodedData as? [[String: Any]] else { return }
        for todoItem in newItems {
            if let item = TodoItem.parse(json: todoItem) {
                addItem(item: item)
            }
        }
    }
    
    func getItemsFromCSV(fileName: String) throws {
        let csvString = try getFromCSVFile(fileName: "\(fileName).csv")
        let items = csvString.split(separator: TodoItem.csvRowsDelimiter)
        for i in 1..<items.count {
            if let item = TodoItem.parse(csv: String(items[i])) {
                addItem(item: item)
            }
        }
    }
    
    private func getDocumentsDirectoryURL() -> URL {
        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectoryUrl
    }
    
    private func getURL(for fileName: String) -> URL {
        return getDocumentsDirectoryURL().appendingPathComponent(fileName)
    }
    
    private func saveToJSONFile(fileName: String, jsonData: Data) throws {
        try jsonData.write(to: getURL(for: fileName))
    }
    
    private func saveToCSVFile(fileName: String, csvString: String) throws {
        try csvString.write(to: getURL(for: fileName), atomically: true, encoding: .utf8)
    }

    
    private func getFromCSVFile(fileName: String) throws -> String {
        return try String(contentsOf: getURL(for: fileName), encoding: .utf8)
    }
    
    private func getFromJSONFile(fileName: String) throws -> Data {
        return try Data(contentsOf: getURL(for: fileName))
    }
    
}

