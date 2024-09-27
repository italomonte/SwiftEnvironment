//
//  AnimalRectangle.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 22/09/24.
//

import SwiftUI

struct AnimalRectangle: View {
    
    var name: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.accentColor)
            
            VStack (alignment: .center){
                Image(name)
                    .resizable()
                    .scaledToFit()
                Text(name)
                    .bold()
                    .font(.headline)
                    .foregroundStyle(.white)
            }.padding()
        }
        .frame(maxHeight: 100)
    }
    
}

