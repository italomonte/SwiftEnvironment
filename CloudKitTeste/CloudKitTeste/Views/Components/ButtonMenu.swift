//
//  Button.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 13/09/24.
//

import Foundation
import SwiftUI

struct ButtonMenu: View {
    
    let name: String
    let color: Color
    var goTo: Binding<Bool>
    
    var body: some View {
        
        Text(name)
            .bold()
            .font(.title2)
            .frame(width: UIScreen.main.bounds.width/2.2, height: UIScreen.main.bounds.width/2.2)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        
        
        
        
        
    }
}


