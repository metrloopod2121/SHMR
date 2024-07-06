//
//  SheetChanges.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.07.2024.
//

import Foundation
import SwiftUI

struct SheetMod: ViewModifier {
    @ObservedObject var modalView: ModalView
    @ObservedObject var viewModel: MainViewModel
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad {
            content
                .sheet(isPresented: $modalView.activateModalView, onDismiss: {
                    modalView.selectedItem = nil
                }) {
                    AddEditView(modalView: modalView)
                        .environmentObject(viewModel)
                }
        } else {
            content
        }
    }
}
