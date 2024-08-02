//
//  SwiftUIView.swift
//  SwiftDataDoZero
//
//  Created by Italo Guilherme Monte on 30/07/24.
//

import SwiftUI
import SwiftData

struct AddAnimal: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    
    var body: some View {
        Form{
            TextField("Animal Name", text: $name)
            Button(action: {
                addItem(name: name)
            }, label: {
                Text("Save")
                    
            })
            
        }
    }
    
    private func addItem(name: String) {
        withAnimation {
            let newAnimal = Animal(name: name)
            modelContext.insert(newAnimal)
            dismiss()
        }
    }
}



#Preview {
    AddAnimal()
}
