//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Italo Guilherme Monte on 02/05/24.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
