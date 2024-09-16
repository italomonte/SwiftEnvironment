//
//  CrudView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 13/09/24.
//

import Foundation
import SwiftUI
import CloudKit


struct CrudView: View {
    
    @ObservedObject var crudVM: CrudViewModel
    
    init(dataVM: DataViewModel) {
        self.crudVM = CrudViewModel(dataVM: dataVM)
    }
    
    var body: some View {
        NavigationView {
            Form{
                
                // Create
                Section ("Create an item") {
                    TextField("Item name", text: $crudVM.itemNameValue)
                    DatePicker("Date Limit", selection: $crudVM.dateValue)
                    
                    Button(action: {
                        crudVM.saveToDoItem()
                    }, label: {
                        Text("Save")
                            .foregroundStyle(Color.accentColor)
                            .bold()
                            .frame(maxWidth: .infinity)
                    })
                }
                
                // Read
                Section("Item List") {
                    List {
                        ForEach (crudVM.toDoItems, id: \.self) { toDoItem  in
                            Text(toDoItem.title)
                                .onTapGesture {
                                    crudVM.updateItem(toDoItem: toDoItem)
                                }
                        }.onDelete(perform: crudVM.deleteItem)
                    }
                }
            }
            
            
            
        }
        .navigationTitle("Crud")
    }
}
