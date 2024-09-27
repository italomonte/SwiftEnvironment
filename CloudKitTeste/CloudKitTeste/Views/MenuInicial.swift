//
//  ContentView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 11/09/24.
//

import SwiftUI

struct MenuInicial: View {
    
    @ObservedObject var dataVM = DataViewModel()
    @ObservedObject var navigationVm = NavigationViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyHGrid(rows: [
                    GridItem(.flexible(minimum: 100, maximum: .infinity)),
                    GridItem(.flexible(minimum: 100, maximum: .infinity)),
                    GridItem(.flexible(minimum: 100, maximum: .infinity))], spacing: 10, content: {
                    
                    
                    NavigationLink {
                        CrudView(dataVM: dataVM)
                    } label: {
                        ButtonMenu(name: "Crud", color: .blue, goTo: $navigationVm.zonesViewIsShowing)
                    }
                    
                    NavigationLink {
                        PushNotificationsView(dataVM: dataVM)
                    } label: {
                        ButtonMenu(name: "Push Notifications", color: .pink, goTo: $navigationVm.zonesViewIsShowing)
                    }
                    
                        NavigationLink {
                            ShareView(dataVM: dataVM)
                        } label: {
                            ButtonMenu(name: "Shared", color: .orange, goTo: $navigationVm.sharedRecordViewIsShowing)
                        }
                    
                    NavigationLink {
                        ImagesView(dataVM: dataVM)
                    } label: {
                        ButtonMenu(name: "Images", color: .mint, goTo: $navigationVm.privacyViewIsShowing)
                    }
                        
                    
                    
                    NavigationLink {
                        ZonesView(dataVM: dataVM)
                    } label: {
                        ButtonMenu(name: "Zones", color: .purple, goTo: $navigationVm.privacyViewIsShowing)
                    }
                        
                    
                    
                    NavigationLink {
                        RateLimitView(dataVM: dataVM)
                    } label: {
                        ButtonMenu(name: "Rate Limiting", color: .gray, goTo: $navigationVm.privacyViewIsShowing)
                    }.disabled(true)
                    
                })
                .padding()
            }
            .padding(.horizontal)
            .navigationTitle("CloudKit")
            .fullScreenCover(isPresented: $navigationVm.crudViewIsShowing, content: {
                Text("crud")
            })
            .toolbar {
                ToolbarItem {
                    HStack{
                        Text("\(dataVM.error)")
                            .foregroundStyle(.red)
                            .bold()
                            .font(.headline)
                        
                        Circle()
                            .frame(width: 20)
                            .foregroundStyle(dataVM.isSignInToiCloud ? .green : .red)
                        
                    }
                }
            }
            
        }
        
        
    }
}


#Preview {
    MenuInicial()
}
