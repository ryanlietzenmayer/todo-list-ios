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
        NavigationStack {
            VStack {
                header
            }
            .padding()
            List {
                ForEach(viewModel.items) { item in
                    let vmitem = ToDoItemViewModel(item: item)
                    TaskView(itemViewModel: vmitem) {
                        removeItem(item)
                    }
                }
            }
        }
    }
    
    func removeItem(_ item: ToDoItem) {
        viewModel.items.removeAll(where: { $0.id == item.id })
    }
    
    var header: some View {
        HStack {
            Button("Settings", systemImage: "gearshape.fill", action: {
                viewModel.getAllToDoItems()
            })
            .labelStyle(.iconOnly)
            .imageScale(.large)
            
            Button("Refresh", systemImage: "arrow.clockwise", action: {
                viewModel.getAllToDoItems()
            })
            .labelStyle(.iconOnly)
            .imageScale(.large)
            
            Spacer()
            Text("Task List")
            Spacer()
            
            Button("Add Section", systemImage: "plus.circle.fill", action: addSection)
                .labelStyle(.iconOnly)
                .imageScale(.large)
            
        }
    }
    
    func addSection() {
        //        let section = ReminderList()
        //        modelContext.insert(section)
        //        path = [section]
    }
    
}

struct TaskView: View {
    // @some state environment for a task
    @State public var itemViewModel: ToDoItemViewModel
    let onDelete: () -> Void // Closure to trigger deletion
    
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
            // "square"
            Button("Checkbox",
                   systemImage: itemViewModel.item.completed
                   ? "checkmark.square.fill"
                   : "square",
                   action: { //$itemViewModel in
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
                onDelete()
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
            //                .alignment(.leading)
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
