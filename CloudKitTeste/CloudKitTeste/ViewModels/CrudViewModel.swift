//
//  CrudViewMode.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 13/09/24.
//

import Foundation
import CloudKit
import SwiftUI


class CrudViewModel: ObservableObject {
    
    var dataVM: DataViewModel
    
    @Published var itemNameValue = ""
    @Published var dateValue = Date()
    @Published var toDoItems: [ToDoItem] = []
    
    let recordType = "ToDoItem"
    
    init(dataVM: DataViewModel) {
        self.dataVM = dataVM
        fetchToDoItems()
    }
    
    private func saveDb (record: CKRecord) {
        self.dataVM.publicDatabase.save(record) { [weak self] record, error in
            if let error {
                print("erro ao salvar dados: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self?.itemNameValue = ""
                self?.dateValue = Date()
                self?.fetchToDoItems()
            }
            
            
            print("dados salvos com sucesso")
            
        }
        
        self.fetchToDoItems()

    }
    
    func saveToDoItem() {
        let record = CKRecord(recordType:  self.recordType)
        
        record.setValuesForKeys([
            "title" : self.itemNameValue,
            "dueDate" : self.dateValue
        ])
        
        self.saveDb(record: record)
        
    }
    
    func fetchToDoItems() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ToDoItem", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedItems: [ToDoItem] = []
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    guard let title = record["title"] as? String else {return}
                    guard let date = record["dueDate"] as? Date else {return}
                    returnedItems.append(ToDoItem(title: title, date: date, record: record))
                    
                case .failure(let error) :
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { returnedRecord in
                guard let title = returnedRecord["title"]  as? String else {return}
                guard let date = returnedRecord["dueDate"] as? Date else {return}
                returnedItems.append(ToDoItem(title: title, date: date, record: returnedRecord))
                
            }
        }
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
//                print("Returned queryResultBlock: \(returnedResult)")
                
                DispatchQueue.main.async {
                    self?.toDoItems = returnedItems

                }
//                print(returnedItems)
            }
        } else {
            queryOperation.queryCompletionBlock = { [weak self] returnedCursor, returnedError in
//                print("Returned queryResultBlock")
                DispatchQueue.main.async {
                    self?.toDoItems = returnedItems
                }
            }
        }
        
        addOperation(operation: queryOperation)
        
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        self.dataVM.publicDatabase.add(operation)
    }
    
    func updateItem (toDoItem: ToDoItem) {
        let record = toDoItem.record
        record["title"] = "New Name!"
        saveDb(record: record)
    }
    
    func deleteItem (indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        
        let toDoItem = toDoItems[index]
        let record = toDoItem.record
        
        dataVM.publicDatabase.delete(withRecordID: record.recordID) { [weak self ] returnedRecordID, returnedError in
            
            DispatchQueue.main.async {
                self?.toDoItems.remove(at: index)
            }
            
        }
        
    }
    
    
    
    
}
