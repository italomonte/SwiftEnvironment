//
//  AnimalCategory.swift
//  SwiftDataDoZero
//
//  Created by Italo Guilherme Monte on 30/07/24.
//

import Foundation
import SwiftData

@Model
class AnimalCategory {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
