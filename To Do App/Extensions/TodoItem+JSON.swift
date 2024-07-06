//
//  ParsingJSON.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 20.06.2024.
//


import Foundation

// MARK: - JSON

extension TodoItem {
    
    static func parse(json: Any) -> TodoItem? {
        guard
            let dictionary = json as? [String:Any],
            let id = (dictionary[Keys.id.rawValue] as? String).map(UUID.init(uuidString:)) ?? nil,
            let text = dictionary[Keys.text.rawValue] as? String,
            let importance = (dictionary[Keys.importance.rawValue] as? String).map(Importance.init(rawValue:)) ?? .regular,
            let isComplete = dictionary[Keys.isComplete.rawValue] as? Bool,
            let createDate = (dictionary[Keys.createDate.rawValue] as? TimeInterval)
                .map(Date.init(timeIntervalSince1970:))
        else { return nil }
        let deadline = (dictionary[Keys.deadline.rawValue] as? TimeInterval)
            .map { interval in Date(timeIntervalSince1970: interval) }
        let changeDate = (dictionary[Keys.changeDate.rawValue] as? TimeInterval)
            .map { interval in Date(timeIntervalSince1970: interval) }
        let color = dictionary[Keys.color.rawValue] as? String
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            createDate: createDate,
            isComplete: isComplete,
            changeDate: changeDate,
            deadline: deadline,
            color: color
        )
    }
    
    
    var json: Any {
        var dataDict: [String: Any] = [:]
        dataDict[Keys.id.rawValue] = id.uuidString
        dataDict[Keys.text.rawValue] = text
        if importance != .regular {
            dataDict[Keys.importance.rawValue] = importance.rawValue
        }
        if let deadline = deadline {
            dataDict[Keys.deadline.rawValue] = deadline.timeIntervalSince1970
        }
        dataDict[Keys.isComplete.rawValue] = isComplete
        dataDict[Keys.createDate.rawValue] = createDate.timeIntervalSince1970
        if let changeDate = changeDate {
            dataDict[Keys.changeDate.rawValue] = changeDate.timeIntervalSince1970
        }
        if let color = color {
            dataDict[Keys.color.rawValue] = color
        }
        return dataDict
    }
    
}


// MARK: - CSV

extension TodoItem {
    static let csvColumnsDelimiter = ";"
    static let csvRowsDelimiter = "\r"
    
    static func parse(csv: Any) -> TodoItem? {
        guard let csv = csv as? String else { return nil }
        let columnsData = csv.components(separatedBy: TodoItem.csvColumnsDelimiter)
        guard
            columnsData.count == 8,
            let id = UUID(uuidString: columnsData[0]),
            let importance = (columnsData[2].isEmpty ? nil : columnsData[2])
                .map(Importance.init(rawValue:)) ?? .regular,
            let isComplete = Bool(columnsData[4]),
            let createdAtInterval = TimeInterval(columnsData[5])
        else { return nil }
        let text = columnsData[1]
        let createDate = Date(timeIntervalSince1970: createdAtInterval)
        let deadline = TimeInterval(columnsData[3])
            .map { interval in Date(timeIntervalSince1970: interval) }
        let changeDate = TimeInterval(columnsData[6])
            .map { interval in Date(timeIntervalSince1970: interval) }
        let color = columnsData[7].isEmpty ? nil : columnsData[7]
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            createDate: createDate,
            isComplete: isComplete,
            changeDate: changeDate,
            deadline: deadline,
            color: color
        )
    }
    
    static var csvTitles: Any {
        var titles: [String] = []
        for cases in Keys.allCases {
            titles.append(cases.rawValue)
        }
        return titles.joined(separator: TodoItem.csvColumnsDelimiter)
    }
    
    var csv: Any {
        var dataArray: [String] = []
        dataArray.append(id.uuidString)
        dataArray.append(text)
        dataArray.append(importance != .regular ? importance.rawValue : "")
        dataArray.append(createDate.timeIntervalSince1970.description)
        dataArray.append(isComplete.description)
        dataArray.append(changeDate?.timeIntervalSince1970.description ?? "")
        dataArray.append(deadline?.timeIntervalSince1970.description ?? "")
        dataArray.append(color ?? "")
        return dataArray.joined(separator: TodoItem.csvColumnsDelimiter)
    }
}
 




extension CaseIterable where Self: Equatable {
    func getIndex() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
}
