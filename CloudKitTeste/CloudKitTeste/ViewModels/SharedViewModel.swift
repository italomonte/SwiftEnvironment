//
//  SharedViewModel.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 21/09/24.
//


import Foundation
import CloudKit
import UIKit
import SwiftUI

class SharedViewModel: ObservableObject {
    
    var dataVM: DataViewModel
    
    var ctUsers = [CKRecord]()
    var currentRecord: CKRecord
    var recordZone: CKRecordZone
    
    init(dataVM: DataViewModel) {
        self.dataVM = dataVM
        self.currentRecord = CKRecord(recordType: "Paciente")  // Initialize with a default value
        recordZone = CKRecordZone(zoneName: "Medical Record")
        dataVM.saveDb(zone: recordZone)
    }
    
    func addRecord() {
        let user = CKRecord(recordType: "Paciente")
        user["name"] = "Italo"
        
        
        let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [user], recordIDsToDelete: nil)
        
        modifyRecordsOperation.modifyRecordsResultBlock = { returnedResultBlock in
            
            switch returnedResultBlock {
            case .success():
                DispatchQueue.main.async{
                    print("Ckrecord salvo com sucesso")
                }
                self.currentRecord = user
            case .failure(let error):
                print(error)
            }
        }
        dataVM.privateDatabase.add(modifyRecordsOperation)
    }
    
    func share() {
        print(currentRecord)
        
        //        let controller = UICloudSharingController { controller, preparationCompletionHandler in
        
        
        
        let share = CKShare(rootRecord: self.currentRecord)
        let controller = UICloudSharingController(share: share, container: dataVM.container)
        controller.availablePermissions = [.allowReadWrite, .allowPrivate]
        
        share[CKShare.SystemFieldKey.title] = "Minha ficha médica" as CKRecordValue
        share.publicPermission = .readWrite
        
        let modifyRecordsOperation = CKModifyRecordsOperation(
            recordsToSave: [self.currentRecord, share],
            recordIDsToDelete: nil)
        
        
        modifyRecordsOperation.modifyRecordsResultBlock = {
            returnedResultBlock in
            
            switch returnedResultBlock {
            case .success():
                print("salvo")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        self.dataVM.privateDatabase.add(modifyRecordsOperation)
        //        }
        
        controller.availablePermissions = [.allowPrivate, .allowReadWrite]
        
    }
    
    func shareRecord(record: CKRecord, completion: @escaping (CKShare?, Error?) -> Void) async {
        
        let share = CKShare(rootRecord: record)
        
        do {
            let _ = try await dataVM.publicDatabase.modifyRecords(
                saving: [record, share],
                deleting: []
            )
        } catch {
            // Handle the error accordingly
            print("Não foi possivel abrir a aba de compartilhamento")
        }
        
        // Aqui você pode definir as propriedades do CKShare, como o título
        share[CKShare.SystemFieldKey.title] = "My Shared Record" as CKRecordValue
        share.publicPermission = .readOnly
        let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [record, share], recordIDsToDelete: nil)
        
        modifyRecordsOperation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                completion(share, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
        
        dataVM.publicDatabase.add(modifyRecordsOperation)
    }
    
}
