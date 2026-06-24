//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Meng Wang on 6/4/26.
//

import SwiftUI

struct ToDoListView: View {
    @State var viewModel = ToDoListViewModel()
    var body: some View {
        VStack {
            header
        }
        .padding()
        List(viewModel.items) {
            TaskView(itemViewModel: ToDoItemViewModel(item: $0))
        }
    }

    var header: some View {
        HStack {
            
            Button("Settings", systemImage: "gearshape.fill", action: {
                viewModel.getAllToDoItems()
            })
            .labelStyle(.iconOnly)
            .imageScale(.large)
            .foregroundStyle(.tint)
            
            Button("Refresh", systemImage: "arrow.clockwise", action: {
                viewModel.getAllToDoItems()
            })
            .labelStyle(.iconOnly)
            .imageScale(.large)
            .foregroundStyle(.tint)

            Spacer()
            Text("Task List")
            Spacer()
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
    }
}

struct TaskView: View {
    // @some state environment for a task
    public var itemViewModel: ToDoItemViewModel

    var body: some View {
        HStack {
            Button("Edit", systemImage: "pencil", action: {
                print("tap pencil")
            })
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .buttonStyle(BorderlessButtonStyle())

            Spacer()
            TaskDetails(item: itemViewModel.item)
            Spacer()
            Button("Checkbox", systemImage: "square", action: {
                print("tap square")
                itemViewModel.toggleCompleted()
            })
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .buttonStyle(BorderlessButtonStyle())
            Spacer()

            Button("Delete", systemImage: "trash.fill", action: {
                print("tap trash")
                itemViewModel.delete()
            })
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .buttonStyle(BorderlessButtonStyle())
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
    let vm = ToDoListViewModel.init(items: [itemA, itemB, itemC, itemD])
//    vm.items = [itemA, itemB, itemC, itemD]
    ToDoListView(viewModel: vm)
}
