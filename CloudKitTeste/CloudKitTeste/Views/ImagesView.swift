//
//  ImagesView.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 17/09/24.
//

import Foundation
import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct ImagesView: View {
    
    @ObservedObject var vm: ImagesViewModel
    
    
    init(dataVM: DataViewModel){
        self.vm = ImagesViewModel(dataVM: dataVM)
    }
    
    var body: some View {
        
        NavigationView {
            Form{
                
                // Create
                Section ("Upoad a Photo") {
                    TextField("Photo name", text: $vm.titleValue)
                    
                    PhotosPicker(
                        selection: $vm.selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                        .onChange(of: vm.selectedPhoto) { _, newItem in
                            Task {
                                // Retrieve selected asset in the form of Data
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    vm.selectedImageData = data
                                    print(type(of: vm.selectedImageData))
                                }
                            }
                        }
                    
                    
                    Button(action: {
                        vm.addPhoto()
                    }, label: {
                        Text("Save")
                            .foregroundStyle(Color.accentColor)
                            .bold()
                            .frame(maxWidth: .infinity)
                    })
                    
                    // Read
                    if let selectedImageData = vm.selectedImageData {
                        if let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            
                        } else {
                            Text("Failed to create image")
                                .foregroundColor(.red)
                        }
                    } else {
                        Text("No image selected")
                            .foregroundColor(.gray)
                    }
                    
                }
                
                Section("Photo List") {
                    List {
                        ForEach (vm.photos, id: \.self) { photo  in
                            LazyVGrid(columns: [GridItem(.fixed(100)), GridItem(.fixed(100))]) {
                                Text(photo.title)
                                    .onTapGesture {
                                        vm.updatePhoto(photo: photo)
                                    }
                                Image(uiImage: (vm.convertCKAssetToUIImage(asset: photo.image) ?? UIImage(named: ""))!)
                                    .frame(width: 200, height: 200)
                                
                            }
                        }.onDelete(perform: vm.deletePhoto)
                    }
                }
            }
            
        }.navigationTitle("Images")
    }
}
