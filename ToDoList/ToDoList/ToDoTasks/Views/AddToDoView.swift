//
//  AddToDoView.swift
//  ToDoList
//
//  Created by Meng Wang on 6/28/26.
//

import SwiftUI

struct AddToDoView: View {
        
    @State
    public var item: ToDoItem
    
    public let isCreate: Bool
    
    @Environment(\.dismiss)
    private var dismiss
    
    var onSave: (_ item: ToDoItem) -> Void
    
    private func save() {
        onSave(item)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Text(isCreate ? "Create" : "Edit")
                .font(.title2)
                .padding(20)
            
            Form {
                TextField("To-Do Item Name", text: $item.taskDescription)
                    .padding(20)
                
                DatePicker("Select Due Date",
                           selection: $item.dueDate,
                           displayedComponents: [.date])
            }
            .scrollContentBackground(.hidden)

            Button(action: save) {
                Text("Save")
            }
            .padding(30)
        }
    }
}

#Preview {
    AddToDoView(item: ToDoItem(taskDescription: "Edit me",
                               dueDate: .distantFuture),
                    isCreate: true) { _ in
    }
}
