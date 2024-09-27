//
//  PushNotificationsView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 18/09/24.
//

import SwiftUI

struct PushNotificationsView: View {
    
    @ObservedObject var vm: PushNotificationsViewModel
    
    init(dataVM: DataViewModel) {
        self.vm = PushNotificationsViewModel(dataVM: dataVM)
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section ("Permissões") {
                    Button("Permitir Notificações") {
                        vm.requestNotificationPermission()
                    }
                }
                
                Section ("Notificações de item novos") {
                    
                    
                    Button("Ativar noticações") {
                        vm.subscribeToNotificationNewItem()
                    }
                    
                    Button("Desativar noticações") {
                        vm.unsubscribeToNotificationNewItem()
                    }
                }
                
                Section ("Notificações de item editados") {
                    
                    
                    Button("Ativar noticações") {
                        vm.subscribeToNotificationEditedItem()
                    }
                    
                    Button("Desativar noticações") {
                        vm.unsubscribeToNotificationEditedItem()
                    }
                }
                
                Section ("Notificações de item deletados") {
                    
                    
                    Button("Ativar noticações") {
                        vm.subscribeToNotificationDeletedItem()
                    }
                    
                    Button("Desativar noticações") {
                        vm.unsubscribeToNotificationDeletedItem()
                    }
                }
            }
            
        
        }.navigationTitle("Push Notifications")
    }
}
