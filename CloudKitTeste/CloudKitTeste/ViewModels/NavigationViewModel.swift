//
//  NavigationViewModel.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 12/09/24.
//

import Foundation

class NavigationViewModel: ObservableObject {
    @Published var crudViewIsShowing = false
    @Published var privacyViewIsShowing = false
    @Published var zonesViewIsShowing = false
    @Published var sharedRecordViewIsShowing = false
}
