//
//  ContentView.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 19.06.2024.
//

import SwiftUI

struct MainView: View {

    //
    @StateObject var viewModel = MainViewModel()
    @StateObject var modalView = ModalView()
    @State private var showCalendar = false
    //
    
    var filter: some View {
        Menu {
            Button(
                action: {
                    viewModel.changeShowButtonValue()
                    viewModel.updateSortedItems()
                },
                label: {
                    Text(viewModel.showButtonText)
                }
            )
            Button(
                action: {
                    viewModel.changeSortButtonValue()
                    viewModel.updateSortedItems()
                },
                label: {
                    Text(viewModel.sortButtonText)
                }
            )
        } label: {
            Label {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
            } icon: {
                Text("")
            }
        }
    }
    
    var header: some View {
        HStack(alignment: .center) {
            Text("Выполнено - \(viewModel.count)")
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            filter
        }
        .textCase(nil)
        .font(.system(size: 17))
        .padding(.bottom, 12)
    }
    
    var section: some View {
        Section {
            ForEach($viewModel.sortedItems) { item in
                TaskView(item: item)
                    .environmentObject(viewModel)
                    .environmentObject(modalView)
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.updateItem(item: viewModel.createItemWithAnotherIsDone(item: item.wrappedValue))
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteItem(id: item.wrappedValue.id)
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        Button {
                            modalView.changeValues(item: item.wrappedValue)
                        } label: {
                            Image(systemName: "info.circle.fill")
                        }
                    }
            }
            footer
                .gesture(
                    TapGesture().onEnded {
                        modalView.changeValues(item: nil)
                    }
                )
        } header: {
            header
        }
    }
    
    
    var footer: some View {
        Text("Новое")
            .padding(.leading, 34)
            .padding([.bottom, .top], 8)
            .foregroundStyle(.gray)
    }
    
    var addButton: some View {
        Button(
            action: {
                modalView.changeValues(item: nil)
            },
            label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .shadow(radius: 20)
                    .modifier(SheetMod(modalView: modalView, viewModel: viewModel))
            }
        )
    }
    
    var content: some View {
        VStack {
            List() {
                section
            }
            .navigationTitle("Мои дела")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showCalendar = true
                    }) {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
        
                    }
                    .sheet(isPresented: $showCalendar) {
                        CalendarView(viewModel: viewModel)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.primaryBG)
        }
        .safeAreaInset(edge: VerticalEdge.bottom) {
            addButton
        }
    }
    
    
    var body: some View {
        chooseView()
        .onAppear {
            do {
                try viewModel.loadItemsFromJSON()
            } catch {
                print("Ошибка при загрузке данных из JSON: \(error)")
            }
        }
    }
    
    
    @ViewBuilder
    func chooseView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            NavigationSplitView {
                content
            } detail: {
                if modalView.activateModalView {
                    AddEditView(modalView: modalView)
                        .environmentObject(viewModel)
                }
            }
        } else {
            NavigationStack {
                content
            }
        }
    }
    
}


#Preview {
    MainView()
}
