//
//  TaskView.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 02.07.2024.
//

import Foundation
import SwiftUI


struct TaskView: View {
    @Binding var item: TodoItem
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject var modalView: ModalView
    
    var importancePredicatWithText: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                if item.importance == .important {
                    Text(Image(systemName: "exclamationmark.2")).foregroundStyle(.red)
                        .fontWeight(.bold)
                }
                Text(item.text)
                    .lineLimit(3)
            }
            if let deadline = item.deadline {
                HStack(alignment: .center) {
                    Text(Image(systemName: "calendar"))
                    Text(deadline.shortDate())
                }
                .font(.system(size: 15))
                .foregroundColor(.gray)
            }
        }
    }
    
    var checkmark: some View {
        Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(item.isComplete ? .green : (item.importance == .important ? .red : .gray))
            .background(
                 Circle()
                    .fill(item.importance == .important ? .red.opacity(0.1) : .clear)
             )
            .gesture(
                TapGesture().onEnded {
                    viewModel.updateItem(item: viewModel.createItemWithAnotherIsDone(item: item))
                }
            )
    }
    
    var chevronButton: some View {
        Button(
            action: {
                modalView.changeValues(item: item)
            },
            label: {
                Image(systemName: "chevron.right")
            }
        )
    }
    
    var body: some View {
        HStack(alignment: .center) {
            checkmark
            importancePredicatWithText
            Spacer()
            if let color = item.color {
                Color(hex: color)
                    .frame(width: 5, height: 20)
                    .cornerRadius(2.5)
            }
            chevronButton
                .foregroundStyle(.gray)
                .modifier(SheetMod(modalView: modalView, viewModel: viewModel))
        }
    }
    
}


#Preview {
    MainView()
}
