//
//  SwiftDataDoZeroApp.swift
//  SwiftDataDoZero
//
//  Created by Italo Guilherme Monte on 30/07/24.
//

import SwiftUI
import SwiftData
@main
struct SwiftDataDoZeroApp: App {
    var body: some Scene {
        WindowGroup {
            Animals()
        }.modelContainer(for: Animal.self)
    }
}
