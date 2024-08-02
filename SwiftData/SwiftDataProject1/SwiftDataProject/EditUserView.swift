//
//  EditUserView.swift
//  SwiftDataProject
//
//  Created by Italo Guilherme Monte on 02/05/24.
//

import SwiftUI
import SwiftData

struct EditUserView: View {
    @Bindable var user: User
    
    var body: some View {
        Form{
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        let user = User(name: "Italo Monte", city: "Rio de Janeiro", joinDate: .now)
        
        return EditUserView(user: user)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription) ")
    }
}
