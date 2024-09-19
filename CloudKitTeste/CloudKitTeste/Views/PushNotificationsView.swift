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
                Button("Permitir Notificações") {
                    vm.requestNotificationPermission()
                }
                
                Button("Ativar noticações") {
                    vm.subscribeToNotification()
                }
                
                Button("Desativar noticações") {
                    vm.unsubscribeToNotification()
                }
            }
            
        
        }.navigationTitle("Push Notifications")
    }
}
