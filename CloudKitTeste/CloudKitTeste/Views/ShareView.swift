//
//  SharedView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 21/09/24.
//

import SwiftUI
import UIKit
import CloudKit

struct CloudSharingView: UIViewControllerRepresentable {
    var share: CKShare
    var container: CKContainer
    
    func makeUIViewController(context: Context) -> UICloudSharingController {
        let controller = UICloudSharingController(share: share, container: container)
        controller.availablePermissions = [.allowReadWrite, .allowPrivate]
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {
        // Atualizações, se necessário
    }
}


struct ShareView: View {
    
    @State private var record = CKRecord(recordType: "TodoItem")
    @State private var share: CKShare?
    @State var isShowingShareView = false
    
    @ObservedObject var vm: SharedViewModel
    
    init(dataVM: DataViewModel) {
        self.vm = SharedViewModel(dataVM: dataVM)
    }
    
    var body: some View {
        VStack {
            
            Button {
                
            } label: {
                Text("Criar record")
            }

            
            Button("Compartilhar record") {
                Task{
                    await vm.shareRecord(record: record) { share, error in
                        if let share = share {
                            self.share = share
                            self.isShowingShareView = true
                        }
                    }
                }
            }
            
            
            
            
        }.sheet(isPresented: $isShowingShareView) {
            if let share = self.share {
                CloudSharingView(share: share, container: vm.dataVM.container)
                    .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
}

