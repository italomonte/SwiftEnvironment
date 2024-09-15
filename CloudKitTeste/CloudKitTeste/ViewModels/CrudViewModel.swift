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
    @Published var toDoItems: [String] = []
    
    let recordType = "ToDoItem"
    
    init(dataVM: DataViewModel) {
        self.dataVM = dataVM
        fetchToDoItems()
    }
    
    private func saveDb (record: CKRecord) {
        self.dataVM.publicDatabase.save(record) { record, error in
            if let error {
                print("erro ao salvar dados: \(error)")
                return
            }
            
            print("dados salvos com sucesso")
            
        }
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
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedItems: [String] = []
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    guard let title = record["title"] as? String else {return}
                    returnedItems.append(title)
                    print(title)
                case .failure(let error) :
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { returnedRecord in
                guard let title = returnedRecord["title"]  as? String else {return}
                returnedItems.append(title)
                
            }
        }
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
                print("Returned queryResultBlock: \(returnedResult)")
                self?.toDoItems = returnedItems
                print(returnedItems)
            }
        } else {
            queryOperation.queryCompletionBlock = { [weak self] returnedCursor, returnedError in
                print("Returned queryResultBlock")
                self?.toDoItems = returnedItems

            }
        }
        
        addOperation(operation: queryOperation)
        
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        self.dataVM.publicDatabase.add(operation)
    }
    
    
    

}
