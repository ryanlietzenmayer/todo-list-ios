//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Meng Wang on 6/4/26.
//

import SwiftUI

struct ToDoListView: View {
    @State private var viewModel = ToDoListViewModel()
//    public var toDoItems: [ToDoItem]
    var body: some View {
        VStack {
            Header()
        }
        .padding()
        List(viewModel.items) {
            TaskView(item: $0)
        }
    }
}

struct Header: View {
    var body: some View {
        HStack {
            Image(systemName: "gear")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Spacer()
            Text("Task List")
            Spacer()
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
    }
}

struct TaskView: View {
    // @some state environment for a task
    public var item: ToDoItem

    var body: some View {
        HStack {
            Button("Edit", systemImage: "pencil", action: {})
                .labelStyle(.iconOnly)
            Spacer()
            TaskDetails(item: item)
            Spacer()
            Button("Checkbox", systemImage: "square", action: {})
                .labelStyle(.iconOnly)
            Button("Delete", systemImage: "trash", action: {})
                .labelStyle(.iconOnly)
        }
    }
}

struct TaskDetails: View {
    public var item: ToDoItem
    var body: some View {
        VStack {
            Text(item.taskDescription)
            Text(item.dueDateString)
            Text(item.createdDateString)
        }
    }
}

#Preview {
    let itemA = ToDoItem(id: 0, taskDescription: "itemA", createdDate: .distantPast, dueDate: .distantFuture, completed: false)
    let itemB = ToDoItem(id: 1, taskDescription: "itemB", createdDate: .distantPast, dueDate: .distantFuture, completed: true)
    let itemC = ToDoItem(id: 2, taskDescription: "itemC", createdDate: .distantPast, dueDate: .distantPast, completed: false)
    let itemD = ToDoItem(id: 3, taskDescription: "itemD", createdDate: .distantPast, dueDate: .distantPast, completed: true)
//    ToDoListView(toDoItems: [itemA, itemB, itemC, itemD])
    
}
