//
//  PushNotificationsViewModel.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 18/09/24.
//

import Foundation
import SwiftUI
import CloudKit

class PushNotificationsViewModel: ObservableObject {
    var dataVM: DataViewModel
    
    init(dataVM: DataViewModel) {
        self.dataVM = dataVM
    }
    
    func requestNotificationPermission() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            
            if let error = error {
                print(error)
            } else if success {
                print ("Notification permission success!")
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }

            } else {
                print ("Notification permission success.")
            }
        }
    }
    
    func subscribeToNotification() {
        
        let predicate = NSPredicate(value: true)
        
        // criar subscriptions para limitar sobre quais record  o user vai ser notificado
        
        let subscriptions = CKQuerySubscription(recordType: "ToDoItem", predicate: predicate, subscriptionID: "to_do_item_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "New task was added in your list"
        notification.subtitle = "See now!"
        notification.soundName = "default"
        
        subscriptions.notificationInfo = notification
        
        dataVM.publicDatabase.save(subscriptions) { returnedSubscription, error in
            if let error = error {
                print(error)
            } else {
                print("success in subscribes notification")
            }
        }
    }
    
    func unsubscribeToNotification() {
        dataVM.publicDatabase.delete(withSubscriptionID: "to_do_item_added_to_database") { returnedID, error in
            if let error = error {
                print(error)
            } else {
                print("success in unsubscribe notification")
            }
        }
    }

}
