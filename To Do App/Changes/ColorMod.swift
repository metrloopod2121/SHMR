//
//  TaskChanges.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.07.2024.
//

import Foundation
import SwiftUI

struct ColorMod: ViewModifier {
    @Binding var todoItem: TodoItem
    func body(content: Content) -> some View {
        if todoItem.isComplete {
            content
                .foregroundStyle(.gray)
                .strikethrough(color: .gray)
        }
        else {
            content
                .foregroundStyle(todoItem.color != nil ? Color(hex: todoItem.color!) : .primary)
                .strikethrough(false)
        }
    }
}
