//
//  ModalView.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 02.07.2024.
//

import Foundation

final class ModalView: ObservableObject {
    @Published var activateModalView = false
    @Published var selectedItem: TodoItem?
    
    func changeValues(item: TodoItem?) {
        selectedItem = item
        activateModalView = true
    }
}
