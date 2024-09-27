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
    
    @ObservedObject var vm: CrudViewModel
    
    init(dataVM: DataViewModel) {
        self.vm = CrudViewModel(dataVM: dataVM)
    }
    
    var body: some View {
        NavigationView {
            Form{
                
                // Create
                Section ("Create an item") {
                    TextField("Item name", text: $vm.itemNameValue)
                    DatePicker("Date Limit", selection: $vm.dateValue)
                    Toggle(isOn: $vm.privateDB) {
                        Text("save in private")
                    }
                    
                    Button(action: {
                        vm.saveToDoItem()
                    }, label: {
                        Text("Save")
                            .foregroundStyle(Color.accentColor)
                            .bold()
                            .frame(maxWidth: .infinity)
                    })
                }
                
                // Read
                Section("Public Item List") {
                    List {
                        ForEach (vm.toDoItems, id: \.self) { toDoItem  in
                            Text(toDoItem.title)
                                .onTapGesture {
                                    vm.updateItem(toDoItem: toDoItem)
                                }
                        }.onDelete(perform: vm.deleteItem)
                    }
                }
                
                Section("Private Item List") {
                    List {
                        ForEach (vm.toDoItemsPrivate, id: \.self) { toDoItem  in
                            Text(toDoItem.title)
                                .onTapGesture {
                                    vm.updateItem(toDoItem: toDoItem)
                                }
                        }.onDelete(perform: vm.deleteItemPrivate)
                    }
                }
            }
            
            
            
        }
        .navigationTitle("Crud")
        .onAppear {
            vm.fetchToDoItems(privateDB: true)
            vm.fetchToDoItems(privateDB: false)
        }
    }
}
