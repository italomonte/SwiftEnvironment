//
//  ContentView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 11/09/24.
//

import SwiftUI

struct Menu: View {
    
    @ObservedObject var dataVM = DataViewModel()
    @ObservedObject var navigationVm = NavigationViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyHGrid(rows: [GridItem(.flexible(minimum: 100, maximum: .infinity)), GridItem(.flexible(minimum: 100, maximum: .infinity)), GridItem(.flexible(minimum: 100, maximum: .infinity)),
                                 GridItem(.flexible(minimum: 100, maximum: .infinity))], spacing: 10, content: {
                
                    
                    NavigationLink {
                        CrudView(dataVM: dataVM)
                    } label: {
                        ButtonMenu(name: "Crud", color: .blue, goTo: $navigationVm.zonesViewIsShowing)
                    }
                    
                    NavigationLink {
                        Text("Authentication")
                    } label: {
                        ButtonMenu(name: "Authentication", color: .purple, goTo: $navigationVm.zonesViewIsShowing)
                    }
                    
                    NavigationLink {
                        Text("Shared")
                    } label: {
                        ButtonMenu(name: "Shared", color: .orange, goTo: $navigationVm.sharedRecordViewIsShowing)
                    }
                    
                    NavigationLink {
                        Text("Zones")
                    } label: {
                        ButtonMenu(name: "Zones", color: .secondary, goTo: $navigationVm.privacyViewIsShowing)
                    }
                    
                    
                    
                    NavigationLink {
                        Text("Images")
                    } label: {
                        ButtonMenu(name: "Images", color: .mint, goTo: $navigationVm.privacyViewIsShowing)
                    }
                    
                    NavigationLink {
                        Text("PushNotifications")
                    } label: {
                        ButtonMenu(name: "Push Notifications", color: .pink, goTo: $navigationVm.privacyViewIsShowing)
                    }
                    
                    NavigationLink {
                        Text("Privacy")
                    } label: {
                        ButtonMenu(name: "Privacy", color: .indigo, goTo: $navigationVm.privacyViewIsShowing)
                    }
                })
                .padding()
            }
            .padding(.horizontal)
            .navigationTitle("CloudKit")
            .fullScreenCover(isPresented: $navigationVm.crudViewIsShowing, content: {
                Text("crud")
            })
        }
        
    }
}


#Preview {
    Menu()
}
