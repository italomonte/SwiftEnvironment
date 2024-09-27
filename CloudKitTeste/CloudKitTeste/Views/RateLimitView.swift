//
//  RteLimitView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 21/09/24.
//

import Foundation
import SwiftUI

struct RateLimitView: View {
    
    @ObservedObject var vm: RateLimitViewModel
    
    init(dataVM: DataViewModel) {
        self.vm = RateLimitViewModel(dataVM: dataVM)
    }
    
    var body: some View {
        NavigationView {
            
            
        }.navigationTitle("Rate Limit")
    
        
    }
}

