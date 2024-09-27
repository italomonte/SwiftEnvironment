//
//  DataViewModel.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 12/09/24.
//

import Foundation
import CloudKit

class DataViewModel: ObservableObject {
    
    let container = CKContainer.default()
    let privateDatabase : CKDatabase
    let publicDatabase : CKDatabase
    
    var dogsZone: CKRecordZone {
        didSet {
            saveDb(zone: dogsZone)
        }
    }
    var catsZone: CKRecordZone {
        didSet {
            saveDb(zone: catsZone)
        }
    }

    
    @Published var isSignInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
   
    init() {
        privateDatabase = container.privateCloudDatabase
        publicDatabase = container.publicCloudDatabase
        dogsZone = CKRecordZone(zoneID: CKRecordZone.ID(zoneName: "DogsZones"))
        catsZone = CKRecordZone(zoneID: CKRecordZone.ID(zoneName: "CatsZones"))

        getiCloudStatus()

        
    }
    
    func saveDb (zone: CKRecordZone) {
        privateDatabase.save(zone) { (zone, error) in
            if let error = error {
                print("Erro ao criar a zona: \(error.localizedDescription)")
            } else {
                print("Zona criada com sucesso: \(zone?.zoneID.zoneName ?? "")")
            }
        }
    }
    
    func getiCloudStatus() {
        self.container.accountStatus { returnedStatus, error in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .available:
                    self.isSignInToiCloud = true
                case .noAccount:
                    self.error = CloudKitError.iCloudAccontNotFound.rawValue
                case .couldNotDetermine:
                    self.error = CloudKitError.iCloudAccontNotDetermined.rawValue
                case .restricted:
                    self.error = CloudKitError.iCloudAccontRestricted.rawValue
                default:
                    self.error = CloudKitError.iCloudAccontUnknown.rawValue

                
                }
            }
        }
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccontNotFound = "Account Not Found"
        case iCloudAccontNotDetermined = "Account Not Determined"
        case iCloudAccontRestricted = "Account Restricted"
        case iCloudAccontUnknown  = "Account Unknown"
    }
    
    
   
    

}
