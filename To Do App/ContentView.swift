//
//  ContentView.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 19.06.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var fileCache = FileCache()
    @State private var showingAddItemSheet = false
    @State private var selectedItem: TodoItem? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(fileCache.todoItems.values.sorted(by: { $0.createDate < $1.createDate }))  { item in
                    HStack {
                        Button(action: {
                            fileCache.toggleComplete(for: item.id)
                        }) {
                            
                            if item.isComplete {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.green)
                                    .frame(width: 24, height: 24)
                            } else if item.importance == .important {
                                Image(systemName: "circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .background( // чтобы внутри кружок был розоватый, хз как по-другому сделать, кто знает, расскажите как
                                        Circle()
                                            .fill(Color.red.opacity(0.1))
                                    )
                                    .frame(width: 24, height: 24)
                            } else {
                                Image(systemName: "circle")
                                    .resizable()
                                    .foregroundStyle(.gray)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(.trailing)
                        .buttonStyle(PlainButtonStyle()) //  для того, чтобы нажатие на строку не меняло isComplete
                        VStack(alignment: .leading) {
                            HStack {
                                if item.importance == .important {
                                    Image(systemName: "exclamationmark.2")
                                        .foregroundStyle(.red)
                                }
                                Text(item.text)
                                    .font(.system(size: 17))
                                    .strikethrough(item.isComplete, color: .gray)
                                    .foregroundStyle(item.isComplete ? .gray : .black)
                                    .lineLimit(3)
                            }
                            
                            HStack(alignment: .bottom) {
                                if let deadlineDate = item.deadline {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                    Text(formatDate(deadlineDate))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedItem = item
                    }
                    .sheet(item: $selectedItem) { item in
                        AddItemView(fileCache: fileCache)
                    }
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            fileCache.toggleComplete(for: item.id)
                        }) {
                            Label("Toggle Complete", systemImage: item.isComplete ? "circle" : "checkmark.circle.fill")
                        }
                        .tint(item.isComplete ? .gray : .green)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            fileCache.removeItem(by: item.id)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }.tint(.red)
                        Button(action: {
                            fileCache.addItem(newItem: item)
                        }) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                Button(
                    action: { showingAddItemSheet.toggle() }) 
                {
                    Text("Новое")
                        .foregroundStyle(.gray)
                        .padding(10)
                }
                
            }
            .navigationTitle("Мои дела")
            
            // Добавляем кнопку в безопасную область снизу поверх списка задач, чтобы не было наложения view
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    showingAddItemSheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()                
                .sheet(isPresented: $showingAddItemSheet) {
                    AddItemView(fileCache: fileCache)
                }
            }
        }
    }
    
    // Функция форматирования даты
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM" 
        return formatter.string(from: date)
    }
}


#Preview {
    ContentView()
}
