//
//  To_Do_AppApp.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 19.06.2024.
//

import SwiftUI
import Foundation
import CocoaLumberjack

@main
struct To_Do_AppApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    init() {
        setupCocoaLumberjack()
    }
    
    private func setupCocoaLumberjack() {
        DDLog.add(DDOSLogger.sharedInstance)
        
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
}


    

    /*
     

     import Foundation
     import SwiftUI
     import CocoaLumberjack

     struct AddEditView: View {
         @ObservedObject var modalView: ModalView
         @EnvironmentObject var viewModel: MainViewModel
         // ... (остальные @State и другие свойства)

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
                     // ... (ваш существующий код для toolbar)
                 }
                 .background(Color.primaryBG)
             }
             .onAppear {
                 DDLogInfo("AddEditView appeared")
             }
             .onDisappear {
                 DDLogInfo("AddEditView disappeared")
             }
             .onReceive(modalView.$selectedItem) { selectedItem in
                 // ... (ваш существующий код)
                 DDLogDebug("Selected item changed: \(String(describing: selectedItem))")
             }
             .onChange(of: text) {
                 isDisabledSave = checkIsDisabledToSave()
                 DDLogDebug("Text changed: \(text)")
             }
             .onChange(of: showColor) {
                 currentColor = showColor ? (currentColor == .clear) ? Color(UIColor.red) : currentColor : .clear
                 isDisabledSave = checkIsDisabledToSave()
                 DDLogDebug("Show color changed: \(showColor), Current color: \(currentColor.description)")
             }
             .onChange(of: showDate) {
                 deadline = !showDate ? Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date() : deadline
                 isDisabledSave = checkIsDisabledToSave()
                 DDLogDebug("Show date changed: \(showDate), Deadline: \(deadline)")
             }
             // ... (остальные модификаторы .onReceive)
         }

         // ... (остальные функции и представления)

         func checkIsDisabledToSave() -> Bool {
             let isDisabled = // ... (ваша существующая логика)
             DDLogDebug("Save button disabled: \(isDisabled)")
             return isDisabled
         }
     }

     #Preview {
         AddEditView(modalView: ModalView())
             .environmentObject(MainViewModel())
     }
     
     */
