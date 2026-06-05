//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Meng Wang on 6/4/26.
//

import SwiftUI

@main
struct ToDoListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(toDoItems: [])
        }
    }
}
