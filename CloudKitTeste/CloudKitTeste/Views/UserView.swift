//
//  UserView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 21/09/24.
//

import SwiftUI

struct UserView: View {
    
    
    @ObservedObject var vm: UserInfoViewModel
    
    init(dataVM: DataViewModel) {
        self.vm = UserInfoViewModel(dataVM: dataVM)
    }
    
    var body: some View {
        Text("Logado: \(vm.isSignInToiCloud.description.uppercased())")
        Text("\(vm.error)")
    }
}


