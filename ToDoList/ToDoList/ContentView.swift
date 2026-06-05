//
//  ContentView.swift
//  ToDoList
//
//  Created by Meng Wang on 6/4/26.
//

import SwiftUI

struct ContentView: View {
    // @Environment
    public var toDoItems: [ToDoItem]
    var body: some View {
        VStack {
            Header()
        }
        .padding()
        List(toDoItems) {
            Task(item: $0)
        }
    }
}

struct Header: View {
    var body: some View {
        HStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Task List")
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
    }
}

struct Task: View {
    // @some state environment for a task
    public var item: ToDoItem

    var body: some View {
        HStack {
            Rectangle()
                .fill(.blue)
            TaskDetails(item: item)
            Rectangle()
                .fill(.blue)
            Rectangle()
                .fill(.blue)
        }
    }
}

struct TaskDetails: View {
    public var item: ToDoItem
    var body: some View {
        VStack {
            Rectangle()
                .fill(.red)
            Rectangle()
                .fill(.green)
            Rectangle()
                .fill(.blue)
        }
    }
}

#Preview {
    let itemA = ToDoItem(id: 0, taskDescription: "itemA", createdDate: .distantPast, dueDate: .distantFuture, completed: false)
    let itemB = ToDoItem(id: 1, taskDescription: "itemB", createdDate: .distantPast, dueDate: .distantFuture, completed: true)
    let itemC = ToDoItem(id: 2, taskDescription: "itemC", createdDate: .distantPast, dueDate: .distantPast, completed: false)
    let itemD = ToDoItem(id: 3, taskDescription: "itemD", createdDate: .distantPast, dueDate: .distantPast, completed: true)
    ContentView(toDoItems: [itemA, itemB, itemC, itemD])
}
