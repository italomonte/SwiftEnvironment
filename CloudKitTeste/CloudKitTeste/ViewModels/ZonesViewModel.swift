import Foundation
import CloudKit
import SwiftUI

struct AnimalName: Hashable {
    var name: String
}



class ZonesViewModel: ObservableObject {
    
    var dataVM: DataViewModel
 
    @Published var fetchedDogZoneList: [AnimalName] = []
    
    @Published var fetchedCatZoneList: [AnimalName] = []
    
    var name = ""

    let catType = "Cat"
    let dogType = "Dog"
    
    init(dataVM: DataViewModel) {
        self.dataVM = dataVM
        self.fetchCatsAndDogs()
    }
    
    private func saveDb (record: CKRecord) {
        self.dataVM.privateDatabase.save(record) { [weak self] record, error in
            if let error {
                print("erro ao salvar dados: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self?.fetchCatsAndDogs()
            }
            
            print("dados salvos com sucesso no private")
        
        }
        
        fetchCatsAndDogs()

    }
    
    func saveInZone(zoneName: String, name: String, recordType: String) {
        
        dataVM.dogsZone = CKRecordZone(zoneID: CKRecordZone.ID(zoneName: "DogsZones"))
        dataVM.catsZone = CKRecordZone(zoneID: CKRecordZone.ID(zoneName: "CatsZones"))
        
        let zoneID = (zoneName == "DogsZones" ? dataVM.dogsZone.zoneID : dataVM.catsZone.zoneID)
        
        let recordID = CKRecord.ID(recordName: name, zoneID: zoneID)

        let animalRecord = CKRecord(recordType: recordType, recordID: recordID)

        animalRecord["name"] = name

        // Salva o registro na zona personalizada
        saveDb(record: animalRecord)
    }
    
    func fetchAnimalsInZone(ofType animalType: String, inZone zone: String, completion: @escaping ([AnimalName]) -> Void) {
        let catZoneID = CKRecordZone.ID(zoneName: zone, ownerName: CKCurrentUserDefaultName)
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: animalType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.zoneID = catZoneID

        var returnedItems: [AnimalName] = []
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    guard let name = record["name"] as? String else { return }
                    returnedItems.append(AnimalName(name: name))
                    
                case .failure(let error):
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { returnedRecord in
                guard let name = returnedRecord["name"] as? String else { return }
                returnedItems.append(AnimalName(name: name))
            }
        }
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { returnedResult in
                DispatchQueue.main.async {
                    completion(returnedItems)
                }
            }
        } else {
            queryOperation.queryCompletionBlock = { returnedCursor, returnedError in
                DispatchQueue.main.async {
                    completion(returnedItems)
                }
            }
        }
        
        addOperation(operation: queryOperation)
    }

    
    
    func fetchCatsAndDogs() {
        var allAnimalsInCatsZone: [AnimalName] = []
        var allAnimalsInDogsZone: [AnimalName] = []
        
        // Fetch Cats
        fetchAnimalsInZone(ofType: self.catType, inZone: "CatsZones") { [weak self] cats in
            allAnimalsInCatsZone.append(contentsOf: cats)
            
            // Fetch Dogs after Cats
            self?.fetchAnimalsInZone(ofType: self?.dogType ?? "Dog", inZone: "CatsZones") { dogs in
                allAnimalsInCatsZone.append(contentsOf: dogs)
                
                // Update the main list with both cats and dogs
                DispatchQueue.main.async {
                    self?.fetchedCatZoneList = allAnimalsInCatsZone
                }
            }
        }
        
        // Fetch Dogs
        fetchAnimalsInZone(ofType: self.catType, inZone: "DogsZones") { [weak self] cats in
            allAnimalsInDogsZone.append(contentsOf: cats)
            
            // Fetch Dogs after Cats
            self?.fetchAnimalsInZone(ofType: self?.dogType ?? "Dog", inZone: "DogsZones") { dogs in
                allAnimalsInDogsZone.append(contentsOf: dogs)
                
                // Update the main list with both cats and dogs
                DispatchQueue.main.async {
                    self?.fetchedDogZoneList = allAnimalsInDogsZone
                }
            }
        }
    }
    
    func deleteOfZone (zone: CKRecordZone) {
        
        dataVM.privateDatabase.delete(withRecordZoneID: zone.zoneID) { returnedId, error in
            if let error = error {
                print(error)
            } else {
                print("Zona deletada com sucesso")
                self.fetchCatsAndDogs()
            }
        }
        
        
    }
    
    func addOperation(operation: CKDatabaseOperation) {
            self.dataVM.privateDatabase.add(operation)
    }
 
}
