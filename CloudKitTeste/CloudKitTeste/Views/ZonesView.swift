//
//  CrudView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 13/09/24.
//

import Foundation
import SwiftUI
import CloudKit

struct ZonesView: View {
    
    @ObservedObject var vm: ZonesViewModel
    
    @State private var selectedOption: String = "Zona dos Gatos"
    @State private var selectedZone: Int = 1
    
    @State private var options = ["Zona dos Gatos", "Zona dos Cachorros"]
    
    init(dataVM: DataViewModel) {
        self.vm = ZonesViewModel(dataVM: dataVM)
    }
    
    var body: some View {
        
        let animalList = [
            Animal(name: "Rex"),
            Animal(name: "Chica"),
            Animal(name: "Fred"),
            Animal(name: "Caramelo"),
        ]
        
        NavigationView {
            ScrollView{
                VStack (alignment: .leading, spacing: 16){
                    Text("Selecione a zona na qual quer salvar os animais e clique animais que desejar.")
                        .font(.title3)
                    
                    Menu {
                        // Lista de opções
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                if option == "Zona dos Gatos" {
                                    selectedZone = 1
                                    print(selectedZone)
                                    selectedOption = option
                                } else {
                                    selectedZone = 2
                                    print(selectedZone)
                                    selectedOption = option

                                }
                                    
                            }) {
                                Text(option)
                            }
                        }
                    } label: {
                        // Label do dropdown
                        Text(selectedOption)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    
                    HStack{
                        Button {
                            vm.saveInZone(zoneName: selectedZone == 1 ? "CatsZones" : "DogsZones", name: animalList[0].name, recordType: vm.dogType)
                        } label: {
                            AnimalRectangle(name: animalList[0].name)
                        }

                        Button {
                            vm.saveInZone(zoneName: selectedZone == 1 ? "CatsZones" : "DogsZones", name: animalList[1].name, recordType: vm.catType)
                        } label: {
                            AnimalRectangle(name: animalList[1].name)
                        }
                    }
                    HStack{
                        Button {
                            vm.saveInZone(zoneName: selectedZone == 1 ? "CatsZones" : "DogsZones", name: animalList[2].name, recordType: vm.catType)
                        } label: {
                            AnimalRectangle(name: animalList[2].name)
                        }

                        Button {
                            vm.saveInZone(zoneName: selectedZone == 1 ? "CatsZones" : "DogsZones", name: animalList[3].name, recordType: vm.dogType)
                        } label: {
                            AnimalRectangle(name: animalList[3].name)
                        }
                        
                    }
                    
                    HStack{
                        Text("Animais da Zona dos Gatos")
                            .bold()
                        Button {
                            vm.deleteOfZone(zone: vm.dataVM.catsZone)
                        } label: {
                            Image(systemName: "trash")
                        }

                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundStyle(.backgroundZoneRectangle)
                            .frame(minHeight: 150)
                        HStack{
                            ForEach (vm.fetchedCatZoneList, id: \.self) { animal in
                                AnimalRectangle(name: animal.name)
                                    .frame(maxWidth: 125)

                            }
                        }.padding()
                    }
                    
                    HStack{
                        Text("Animais da Zona dos Cachorros")
                            .bold()
                        Button {
                            vm.deleteOfZone(zone: vm.dataVM.dogsZone)
                        } label: {
                            Image(systemName: "trash")
                        }

                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundStyle(.backgroundZoneRectangle)
                            .frame(minHeight: 150)
                        HStack{
                            ForEach (vm.fetchedDogZoneList, id: \.self) { animal in
                                AnimalRectangle(name: animal.name)
                                    .frame(maxWidth: 125)
                            }
                        }
                        .padding()

                    }

                    
                    Spacer()
                    
                }
                
            }
            .scrollIndicators(.hidden)
            
        }
        .padding()
        .navigationTitle("Zones")
        .onAppear {
            vm.fetchCatsAndDogs()
        }
    }
}

#Preview{
    ZonesView(dataVM: DataViewModel())
}
