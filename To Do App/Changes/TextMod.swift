//
//  TextMod.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.07.2024.
//

import SwiftUI

struct TextMod: ViewModifier {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    func body(content: Content) -> some View {
        if verticalSizeClass == .compact || horizontalSizeClass == .regular {
            content
                .frame(minHeight: UIScreen.main.bounds.size.height * (4/5), alignment: .top)
        }
        else {
            content
                .frame(minHeight: 120, alignment: .top)
        }
    }
}

