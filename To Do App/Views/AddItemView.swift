//
//  NewItemView.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 25.06.2024.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var fileCache: FileCache
    @State private var newItemText = ""
    @State private var newTask = TodoItem(text: "")
    @State private var deadlineEnabled = false
    @State private var showDatePicker = false
    @State private var deadline = Date()
    @State private var selectedPriority: TodoItem.Importance = .unimportant
    @State private var selectedColor = Color.blue // Default color

    
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    TextField("Что нужно сделать?", text: $newItemText, axis: .vertical)
                        .font(.title3)
                        .lineLimit(3, reservesSpace: true)
                    Color(selectedColor)
                                .frame(width: 5, height: 100)
                                .cornerRadius(2.5)
                }
                
                Section {
                    HStack {
                        Text("Важность")
                        Spacer()
                        Picker("Важность", selection: $selectedPriority) {
                            Image(systemName: TodoItem.Importance.unimportant.rawValue)
                                .tag(TodoItem.Importance.unimportant)
                            
                            Text("нет")
                                .tag(TodoItem.Importance.regular)
                            
                            Image(systemName: TodoItem.Importance.important.rawValue)
                                .symbolRenderingMode(.palette)
                                .foregroundColor(.red)
                                .tag(TodoItem.Importance.important)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .scaledToFit()
                    }
                    
                    Toggle(isOn: $deadlineEnabled) {
                        VStack(alignment: .leading) {
                            Text("Сделать до")
                            
                            if deadlineEnabled {
                                Text(formatDate(deadline))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        withAnimation {
                                            showDatePicker.toggle()
                                        }
                                    }
                            }
                        }
                    }
                    .onChange(of: deadlineEnabled) { newValue in
                        if newValue {
                            // Устанавливаем дедлайн на следующий день после текущей даты
                            deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                        } else {
                            showDatePicker = false
                        }
                    }
                    
                    
                    if deadlineEnabled && showDatePicker {
                        DatePicker("Выберите дату", selection: $deadline, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .opacity(showDatePicker ? 1 : 0) // Начальное значение прозрачности
                            .offset(x: showDatePicker ? 0 : UIScreen.main.bounds.width, y: 0) // Выезжание справа
                    }
                    
                    
                }
                
                Section {
                    Section(header: Text("Цвет")) {
                        ColorPicker(selectedColor.hexComponents(), selection: $selectedColor, supportsOpacity: false)
                    }
                }
                
                Button("Удалить") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundStyle(.red)
                .font(.system(size: 17))
                .padding(10)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Дело")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationBarItems(
                leading: Button("Отменить") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Сохранить") {
                    guard !newItemText.isEmpty else { return }
                    
                    var newTask = TodoItem(
                        text: newItemText,
                        importance: selectedPriority,
                        createDate: Date(),
                        isComplete: false,
                        color: selectedColor
                    )
                    
                    if deadlineEnabled {
                        newTask.deadline = deadline
                    }
                    
                    fileCache.addItem(newItem: newTask)
                    presentationMode.wrappedValue.dismiss()
                }.fontWeight(.bold)
            )
        }
    }

    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM YYYY" 
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
