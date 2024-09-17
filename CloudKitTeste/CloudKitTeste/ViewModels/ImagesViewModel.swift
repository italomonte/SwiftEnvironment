//
//  CrudViewMode.swift
//  CloudKitTeste
//
//  Created by Italo Guilherme Monte on 13/09/24.
//

import Foundation
import CloudKit
import SwiftUI
import PhotosUI

class ImagesViewModel: ObservableObject {
    
    var dataVM: DataViewModel
    
    @Published var selectedPhoto: PhotosPickerItem? {
        didSet {
            if let selectedPhoto {
                convertPhotoToCKAsset(photo: selectedPhoto)
            }
        }
    }
    
    @Published var selectedImageData: Data? = nil
    @Published var titleValue = ""
    @Published var photos: [Photo] = []
    
    var imageValue: CKAsset?
    
    let recordType = "Photo"
    
    init(dataVM: DataViewModel) {
        self.dataVM = dataVM
        fetchPhotos()
    }
    
    private func saveDb (record: CKRecord) {
        self.dataVM.publicDatabase.save(record) { [weak self] record, error in
            if let error {
                print("erro ao salvar dados: \(error)")
                return
            }
            
            DispatchQueue.main.sync {
                self?.titleValue = ""
                self?.imageValue = nil
                self?.fetchPhotos()
            }
            
            
            print("dados salvos com sucesso")
            
        }
        
        self.fetchPhotos()

    }
    
    func addPhoto() {
            let newPhoto = CKRecord(recordType: self.recordType)
        
            newPhoto["title"] = self.titleValue

            guard let image = imageValue else {
                print("Nenhuma imagem foi selecionada.")
                return
            }

            newPhoto["image"] = image
            self.saveDb(record: newPhoto)
        }

        func convertPhotoToCKAsset(photo: PhotosPickerItem) {
            photo.loadTransferable(type: Data.self) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let data = data {
                            self?.saveImageToTemporaryDirectory(imageData: data)
                        }
                    case .failure(let error):
                        print("Erro ao carregar imagem: \(error)")
                    }
                }
            }
        }

        func saveImageToTemporaryDirectory(imageData: Data) {
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
            
            do {
                try imageData.write(to: fileURL)
                self.imageValue = CKAsset(fileURL: fileURL)
            } catch {
                print("Erro ao salvar imagem no diretório temporário: \(error)")
            }
        }
    
        func convertCKAssetToUIImage(asset: CKAsset) -> UIImage? {
            if let assetURL = asset.fileURL {
                do {
                    let imageData = try Data(contentsOf: assetURL)
                    
                    return UIImage(data: imageData)
                } catch {
                    print("Erro ao carregar os dados da imagem: \(error)")
                    return nil
                }
            }
            
            return nil
        }
    
    func fetchPhotos() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: self.recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedItems: [Photo] = []
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    guard let title = record["title"] as? String else {return}
                    guard let image = record["image"] as? CKAsset else {return}
                    returnedItems.append(Photo(title: title, image: image, record: record))
                    
                case .failure(let error) :
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { returnedRecord in
                guard let title = returnedRecord["title"]  as? String else {return}
                guard let image = returnedRecord["image"] as? CKAsset else {return}
                returnedItems.append(Photo(title: title, image: image, record: returnedRecord))
                
            }
        }
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
//                print("Returned queryResultBlock: \(returnedResult)")
                
                DispatchQueue.main.sync {
                    self?.photos = returnedItems

                }
//                print(returnedItems)
            }
        } else {
            queryOperation.queryCompletionBlock = { [weak self] returnedCursor, returnedError in
//                print("Returned queryResultBlock")
                DispatchQueue.main.sync {
                    self?.photos = returnedItems
                }
            }
        }
        
        addOperation(operation: queryOperation)
        
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        self.dataVM.publicDatabase.add(operation)
    }
    
    func updatePhoto (photo: Photo) {
        let record = photo.record
        record["title"] = "New Name!"
        saveDb(record: record)
    }
    
    func deletePhoto (indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        
        let photo = photos[index]
        let record = photo.record
        
        dataVM.publicDatabase.delete(withRecordID: record.recordID) { [weak self ] returnedRecordID, returnedError in
            
            DispatchQueue.main.async {
                self?.photos.remove(at: index)
            }
            
        }
        
    }
    
    
    
    
}
