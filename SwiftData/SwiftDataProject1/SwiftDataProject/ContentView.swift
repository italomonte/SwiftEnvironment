//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Italo Guilherme Monte on 02/05/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \User.joinDate) var users: [User]
    @State private var path = [User]()
    @State var showingAddView = false
    
    var body: some View {
        NavigationStack() {
            List(users){ user in
                NavigationLink(value: user) {
                    Text(user.name)
                }
            }
            
            .navigationTitle("Users")
            .navigationDestination(for: User.self){user in
                EditUserView(user: user)
            }
            .toolbar{
                Button("Add User", systemImage: "plus"){
                    showingAddView.toggle()
                }
            }
            .sheet(isPresented: $showingAddView, content: {
                AddUserView(user: User(name: "", city: "", joinDate: .now))
            })
        }
    }
}

#Preview {
    ContentView()
}
