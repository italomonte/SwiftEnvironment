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
    
    init() {
        privateDatabase = container.privateCloudDatabase
        publicDatabase = container.publicCloudDatabase
    }
    

}
