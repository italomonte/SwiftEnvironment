//
//  ContentView.swift
//  VisionOS&iOS_Test
//
//  Created by Italo Guilherme Monte on 24/07/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = DeviceFinderViewModel()

        var body: some View {
            NavigationStack {
                List(model.peers) { peer in
                    HStack {
                        Image(systemName: "iphone.gen1")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)

                        Text(peer.peerId.displayName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 5)
                }
                .onAppear {
                    model.startBrowsing()
                }
                .onDisappear {
                    model.finishBrowsing()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Toggle("Press to be discoverable", isOn: $model.isAdvertised)
                            .toggleStyle(.switch)
                    }
                }
            }
        }
}


struct ContentViewTwo: View {
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerSize: /*@START_MENU_TOKEN@*/CGSize(width: 20, height: 10)/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                .tint(.gray)
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
