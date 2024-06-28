//
//  To_Do_AppApp.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 19.06.2024.
//

import SwiftUI
import Foundation

//TodoItem
//Иммутабельная структура
//Содержит уникальный идентификатор id, если не задан пользователем — генерируется (UUID().uuidString)
//Содержит обязательное строковое поле — text
//Содержит обязательное поле важность, должно быть enum, может иметь три варианта — «неважная», «обычная» и «важная»
//Содержит дедлайн, может быть не задан, если задан — дата
//Содержит флаг того, что задача сделана
//Содержит две даты — дата создания задачи (обязательна) и дата изменения (опциональна)

@main
struct To_Do_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.gray)
        }
    }
}


    


