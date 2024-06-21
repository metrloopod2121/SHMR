//
//  ContentView.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 19.06.2024.
//

import SwiftUI

struct ContentView: View {
    

    
    var body: some View {
        VStack {
            Text("Hello, world!")
            Button(
                action: {
                    let someCache = FileCache()
                    let newItem1 = ToDoItem(id: "1", text: "buy milk")
                    let newItem2 = ToDoItem(id: "2", text: "buy eggs")
                    someCache.addItem(newItem: newItem1)
                    someCache.addItem(newItem: newItem2)
                    someCache.saveData(to: "data")
//                    print(someCache.ToDoItems)
                    
                }, label: {
                    Text("tap tap")
                }
            )
        }
        .padding()

    }
}

#Preview {
    ContentView()
}
