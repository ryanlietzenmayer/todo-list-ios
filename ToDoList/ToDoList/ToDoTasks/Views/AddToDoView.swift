//
//  AddToDoView.swift
//  ToDoList
//
//  Created by Meng Wang on 6/28/26.
//

import SwiftUI

struct AddToDoView: View {
    @State
    private var item = ToDoItem(taskDescription: "")
    
    @Environment(\.dismiss)
    private var dismiss
    
    var onSave: (_ item: ToDoItem) -> Void
    
    private func save() {
        onSave(item)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Text("Create")
                .font(.title2)
            
            Form {
                TextField("To-Do Item Name", text: $item.taskDescription)
            }

            Button(action: save) {
                Text("Save")
            }
        }
    }
}

#Preview {
    AddToDoView { _ in
        
    }
}
