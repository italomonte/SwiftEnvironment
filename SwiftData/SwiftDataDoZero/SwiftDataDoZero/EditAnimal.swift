//
//  EditAnimal.swift
//  SwiftDataDoZero
//
//  Created by Italo Guilherme Monte on 02/08/24.
//


import SwiftUI
import SwiftData

struct EditAnimal: View {
    
    @Bindable var animal: Animal
    
    var body: some View {
        Form{
            TextField("Animal Name", text: $animal.name)
        }
    }

}


