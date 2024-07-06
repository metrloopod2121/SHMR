//
//  ColorPicker.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 02.07.2024.
//

import Foundation
import SwiftUI


struct ColorPickerView: View {
    @State private var brightness: Double = 1.0
    
    var slider: some View {
        Slider(value: $brightness, in: 0...1, step: 0.01)
    }
    
    var body: some View {
//        ColorPicker(selectedColor.hexComponents(), selection: $selectedColor, supportsOpacity: false)
        slider
    }
}

#Preview {
    AddEditView(modalView: ModalView())
        .environmentObject(MainViewModel())
}
