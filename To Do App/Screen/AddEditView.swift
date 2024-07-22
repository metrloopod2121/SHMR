//
//  AddEditView.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 02.07.2024.
//

import Foundation
import SwiftUI

struct AddEditView: View {
    @ObservedObject var modalView: ModalView
    @EnvironmentObject var viewModel: MainViewModel
    @State var text: String = ""
    @State var selectedImportance = 2
    @State var showDate = false
    @State var showCalendar = false
    @State var showColor = false
    @State var showPicker = false
    @State var currentColor: Color = .clear
    @State var deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State var isHidden = false
    @State var isDisabledSave = true
    @State var isDisabledDelete = false
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var currentColorHex: String {
        currentColor.hexComponentsString()
    }
//    @State var categoryOfItem: Category = .work
    @State private var categoryOfItem: Int = 3
    let categories: [Int: String] = [0: Category.work.rawValue, 1: Category.study.rawValue, 2: Category.hobby.rawValue, 3: Category.other.rawValue]
    
    
    // MARK: Item's Text Field
    
    var textField: some View {
        ZStack(alignment: .topLeading) {
            TextField("Что надо сделать?", text: $text, axis: .vertical)
                .multilineTextAlignment(.leading)
                .lineLimit(.none)
                .modifier(TextMod())
        }
        .padding()
        .padding(.bottom, 6)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.secondaryBG)
        )
    }
    
    var itemTextSection: some View {
        ZStack (alignment: .trailing) {
            textField
            Color(currentColor)
                .frame(width: 5, height: 80)
                .cornerRadius(2.5)
                .padding()
        }
        
    }
    
    
    // MARK: Item's Importance, Deadline, Color
    
    var importancePicker: some View {
        HStack {
            Text("Важность")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color(UIColor.label))
            Spacer()
            Picker("Picker", selection: $selectedImportance) {
                Image(systemName: "arrow.down").tag(0)
                    .foregroundStyle(.gray, .blue)
                Text("нет").tag(1)
                Image(systemName: "exclamationmark.2").tag(2)
                    .foregroundStyle(.red, .blue)
            }
            .onChange(of: selectedImportance) {
                isDisabledSave = checkIsDisabledToSave()
            }
            .frame(width: 150)
            .pickerStyle(SegmentedPickerStyle())
        }
        .frame(height: 40)
    }
    
    
    var colorPicker: some View {
        VStack {
            HStack {
                Text("Цвет")
                Spacer()
                Toggle("", isOn: $showColor)
            }
            .foregroundStyle(Color(UIColor.label))
            .frame(height: 40)
            
            if showColor {
                ColorPicker(currentColor.hexComponentsString(), selection: $currentColor, supportsOpacity: false)
            }
        }
        
    }

    
    var toggleDeadline: some View {
        Toggle("", isOn: $showDate).onReceive([showDate].publisher.first(), perform: { value in
            if !value {
                showCalendar = false
            }
            isDisabledSave = checkIsDisabledToSave()
        })
    }
    
    var deadlineSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Сделать до")
                    .foregroundStyle(Color(UIColor.label))
                if showDate {
                    Text(deadline.mediumDate())
                        .foregroundStyle(.blue)
                        .font(.caption)
                        .gesture(
                            TapGesture().onEnded({
                                withAnimation {
                                    showCalendar.toggle()
                                }
                            })
                        )
                }
            }
            .frame(height: 40)
            toggleDeadline
        }
        .frame(height: 40)
        
    }
    
    var datePicker: some View {
        DatePicker(
            "Date",
            selection: $deadline,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
    }
    
    var deleteButton: some View {
        Button(action: {
            if let id = modalView.selectedItem?.id {
                viewModel.deleteItem(id: id)
            }
            modalView.activateModalView = false
        }, label: {
            Text("Удалить")
                .foregroundStyle(isDisabledDelete ? .gray : .red)
        }).disabled(isDisabledDelete)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.secondaryBG)
        )
    }
    
    var categoryPicker: some View {
        HStack(alignment: .center) {
            Text("Выбери категорию")
            Spacer()
            Picker("", selection: $categoryOfItem) {
                Text("Работа").tag(0)
                Text("Учёба").tag(1)
                Text("Хобби").tag(2)
                Text("Другое").tag(3)
            }
        }
    }
    
    var settings: some View {
        VStack {
            VStack {
                importancePicker
                Divider()
                colorPicker
                Divider()
                deadlineSection
                if showCalendar {
                    Divider()
                    datePicker
                }
                Divider()
                categoryPicker
            }
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.secondaryBG)
            )
            deleteButton
        }
    }

    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    itemTextSection
                    settings
                }
            }
            .scrollIndicators(.hidden)
            .padding(.all, 16)
            .navigationTitle("Дело")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        let deadline = showDate ? deadline : nil
                        let color = showColor ? currentColorHex : nil
                        viewModel.updateItem(
                            item: viewModel.createNewItem(
                                item: modalView.selectedItem,
                                text: text,
                                importance: selectedImportance,
                                deadline: deadline,
                                color: color,
                                category: Category(rawValue: categories[categoryOfItem]!)!))
                        modalView.activateModalView = false
                    }.disabled(isDisabledSave)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        modalView.activateModalView = false
                    }
                }
            }
            .background(Color.primaryBG)
        }
        .onReceive(modalView.$selectedItem) { selectedItem in
            if selectedItem == nil {
                isDisabledDelete = true
            }
            text = selectedItem?.text ?? ""
            selectedImportance = Int(selectedItem?.importance.getIndex() ?? 2)
            if let color = selectedItem?.color {
                currentColor = Color(hex: color)
                showColor = true
            }
            if let deadline = selectedItem?.deadline {
                self.deadline = deadline
                showDate = true
            }
            
        }
        .onChange(of: text) {
            isDisabledSave = checkIsDisabledToSave()
        }
        .onChange(of: showColor) {
            currentColor = showColor ? (currentColor == .clear) ? Color(UIColor.red) : currentColor : .clear
            isDisabledSave = checkIsDisabledToSave()
        }
        .onChange(of: showDate) {
            deadline = !showDate ? Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date() : deadline
            isDisabledSave = checkIsDisabledToSave()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            withAnimation {
                isHidden = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            withAnimation {
                isHidden = false
            }
        }
    }

       
    
    @ViewBuilder
    func chooseRightView() -> some View {
        if verticalSizeClass == .compact || horizontalSizeClass == .regular {
            HStack {
                ScrollView {
                    itemTextSection
                }
                if !isHidden {
                    ScrollView {
                        settings
                    }
                }
            }
        } else {
            VStack {
                ScrollView {
                    itemTextSection
                    settings
                }
            }
        }
    }
    
    
    func checkIsDisabledToSave() -> Bool {
        guard !text.isEmpty,
              currentColorHex != modalView.selectedItem?.color && showColor ||
              !showColor && modalView.selectedItem?.color != nil ||
//              !deadline.isEqualDay(with: modalView.selectedItem?.deadline) && showDate ||
              !showDate && modalView.selectedItem?.deadline != nil ||
//              selectedImportance != modalView.selectedItem?.importance.getIndex() ||
              text != modalView.selectedItem?.text
        else { return true }
        return false
    }
}

#Preview {
    AddEditView(modalView: ModalView())
        .environmentObject(MainViewModel())
}



