//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Meng Wang on 6/4/26.
//

import SwiftUI

struct ToDoListView: View {
    @State
    var viewModel = ToDoListViewModel()
    
    @State
    private var isAddItemDialogPresented = false
    
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
                    .listRowSeparator(.hidden)
                    .padding(12)
                    .background(Color.gray.opacity(0.30))
                    .cornerRadius(8)
                }
            }
            .contentMargins(.top, 0)
            .scrollContentBackground(.hidden)
        }
    }
    
    var header: some View {
        ZStack {
            Text("Task List")
                .font(.title2)
            
            HStack {
                Button("Settings", systemImage: "gearshape.fill", action: {
                    viewModel.getAllToDoItems()
                })
                .labelStyle(.iconOnly)
                .imageScale(.large)
                
                Button("Refresh", systemImage: "arrow.clockwise",
                       action: {
                    viewModel.getAllToDoItems()
                })
                .labelStyle(.iconOnly)
                .imageScale(.large)
                
                Spacer()
                
                Button("Add Section", systemImage: "plus.circle.fill",
                       action: presentAddItemView)
                .labelStyle(.iconOnly)
                .imageScale(.large)
            }
            .sheet(isPresented: $isAddItemDialogPresented) {
                AddToDoView(item: ToDoItem(taskDescription: ""),
                            isCreate: true) { item in
                    viewModel.create(item)
                }
            }
        }
    }
    
    private func removeItem(_ item: ToDoItem) {
        viewModel.items.removeAll(where: { $0.id == item.id })
    }
    
    private func presentAddItemView() {
        isAddItemDialogPresented.toggle()
    }
}

struct TaskView: View {
    @State public var itemViewModel: ToDoItemViewModel
    let onDelete: () -> Void // Closure to trigger deletion
    
    @State var showingDetail = false
    
    var body: some View {
        HStack(spacing: 16) {
            
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Label("Edit", systemImage: "pencil")
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
                    .buttonStyle(BorderlessButtonStyle())
            }.sheet(isPresented: $showingDetail) {
                AddToDoView(item: itemViewModel.item,
                            isCreate: false) { item in
                    itemViewModel.editCompleted(item)
                }
            }
            
            TaskDetails(item: itemViewModel.item)
            
            Spacer()
            
            Button("Checkbox",
                   systemImage: itemViewModel.item.completed
                   ? "checkmark.square.fill"
                   : "square",
                   action: {
                itemViewModel.toggleCompleted()
            })
            .labelStyle(.iconOnly)
            .imageScale(.large)
            .buttonStyle(BorderlessButtonStyle())
            
            Button("Delete", systemImage: "trash.fill", action: {
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
        VStack(alignment: .leading, spacing: 4) {
            Text(item.taskDescription)
            Text(item.dueDateString)
                .font(.caption)
            Text(item.createdDateString)
                .font(.caption)
        }
    }
}

#Preview {
    let itemA = ToDoItem(id: 0, taskDescription: "itemA", createdDate: .distantPast, dueDate: .distantFuture, completed: false)
    let itemB = ToDoItem(id: 1, taskDescription: "itemB", createdDate: .distantPast, dueDate: .distantFuture, completed: true)
    let itemC = ToDoItem(id: 2, taskDescription: "itemC", createdDate: .distantPast, dueDate: .distantFuture, completed: false)
    let itemD = ToDoItem(id: 3,
                         taskDescription: "itemD Multiline Text Multiline Text Multiline Text",
                         createdDate: .distantPast,
                         dueDate: .distantPast,
                         completed: true)
    let vm = ToDoListViewModel.init(items: [itemA, itemB, itemC, itemD])
    ToDoListView(viewModel: vm)
}
