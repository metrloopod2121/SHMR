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
    @State private var showCompletedTasks = true
    let filterOptions = ["Сортировать по добавлению", "Сортировать по важности"]
    @State private var selectedFilter = "Скрыть/Показать"
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack(alignment: .bottom) {
                    Text("Выполнено - \(fileCache.countOfCompletedTasks)")
                        .padding(.leading)
                        .foregroundColor(.gray)
                    Spacer()
//                    Menu {
//                       ForEach(filterOptions, id: \.self) { option in
//                           Button(action: {
//                               selectedFilter = option
//                           }) {
//                               Text(option)
//                           }
//                       }
//                   } label: {
//                       Label(selectedFilter, systemImage: "line.horizontal.3.decrease.circle")
//                           .padding(.trailing)
//                           .foregroundColor(.blue)
//                   }
//                   .menuStyle(BorderlessButtonMenuStyle())
                    Button(action: {
                        showCompletedTasks.toggle()
                    }) {
                        Text(showCompletedTasks ? "Скрыть" : "Показать")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                }
                .padding([.top, .bottom], 10)
                List {
                    ForEach(fileCache.todoItems.values.filter { showCompletedTasks || !$0.isComplete }.sorted(by: { $0.createDate < $1.createDate })) { item in
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
                                        .foregroundStyle(item.isComplete ? .gray : .primary)
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
                            
                            Color(item.color)
                                        .frame(width: 5, height: 20)
                                        .cornerRadius(2.5)
                            
                            Image(systemName: "chevron.right")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
//                            showingAddItemSheet.toggle()
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
                }
                .sheet(isPresented: $showingAddItemSheet) {
                    AddItemView(fileCache: fileCache)
                }
                .navigationTitle("Мои дела")
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
