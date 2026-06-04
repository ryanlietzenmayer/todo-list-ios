//
//  ContentView.swift
//  ToDoList
//
//  Created by Meng Wang on 6/4/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Header()
        }
        .padding()
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
    var body: some View {
        HStack {
            Rectangle()
                .fill(.blue)
            TaskDetails()
            Rectangle()
                .fill(.blue)
            Rectangle()
                .fill(.blue)
        }
    }
}

struct TaskDetails: View {
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
    ContentView()
    Task()
    Task()
    Task()
}
