//
//  EditUserView.swift
//  SwiftDataProject
//
//  Created by Italo Guilherme Monte on 02/05/24.
//

import SwiftUI
import SwiftData

struct AddUserView: View {
    @Bindable var user: User
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss // ???
    
    var body: some View {
        Form{
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
            
            Button("Save") {
                modelContext.insert(user)
                dismiss()
            }
            
        }
        .navigationTitle("Add User")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
}


#Preview {
    AddUserView(user: User(name: "Italo Monte", city: "Rio de Janeiro", joinDate: .now))
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: User.self, configurations: config)
        
        /*return */
//            .modelContainer(container)
//    } catch {
//        return Text("Failed to create container: \(error.localizedDescription) ")
//    }
}

