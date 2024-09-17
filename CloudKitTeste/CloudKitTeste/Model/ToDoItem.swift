//
//  ToDoItem.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 15/09/24.
//

import Foundation
import CloudKit


struct ToDoItem: Hashable {
    var title: String
    var date: Date
    let record: CKRecord
}
