//
//  Categories.swift
//  SwiftDataDoZero
//
//  Created by Italo Guilherme Monte on 30/07/24.
//

import SwiftUI
import SwiftData
struct Animals: View {
    
    @State var isShowingAddAnimal: Bool = false
    @Environment(\.modelContext) var context
    @Query var animals: [Animal]
    
    var body: some View {
        NavigationStack{
            List{
                ForEach (animals) { animal in
                    NavigationLink(destination: EditAnimal(animal: animal)) {
                        Text(animal.name)
                    }
                    
                }
                .onDelete{ indexSet in
                    for index in indexSet {
                        context.delete(animals[index])
                    }
                }
            }
            .navigationTitle("Animals")
            .toolbar{
                ToolbarItem {
                    Button(action: {
                        isShowingAddAnimal = true
                        print(isShowingAddAnimal)
                    }, label: {
                        Label("Add Animal", systemImage: "plus")
                    })
                    
                }
            }
            .sheet(isPresented: $isShowingAddAnimal) {
                AddAnimal()
            }

        }
        
    }
}


#Preview {
    Animals()
}
