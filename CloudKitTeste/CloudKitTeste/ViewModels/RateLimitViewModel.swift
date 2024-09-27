import Foundation
import CloudKit

class RateLimitViewModel: ObservableObject {
    
    var dataVM: DataViewModel
    
    init (dataVM: DataViewModel) {
        self.dataVM = dataVM
        // Chamar a função de simulação
//        self.simulateRateLimiting()
    }
    
    // Função que faz uma requisição ao CloudKit
    func performCloudKitRequest() {
  
        let query = CKQuery(recordType: "ToDoItem", predicate: NSPredicate(value: true))
        
        
        let operation = CKQueryOperation(query: query)
        
        
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    print("Registro encontrado: \(record)")
                    
                case .failure(let error) :
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            operation.recordFetchedBlock = { record in
                // Processar o registro
                print("Registro encontrado: \(record)")
            }
        }
        
        if #available(iOS 15.0, *) {
            operation.queryResultBlock = { returnedResult in
                switch returnedResult {
                case .success(_):
                    print("Consulta concluída com sucesso")
                case .failure(let error):
                    print("Não foi possivel consultar: \(error.localizedDescription)")

                }
            }
            
        } else  {
            operation.queryCompletionBlock = { cursor, error in
                if let ckError = error as? CKError {
                    switch ckError.code {
                    case .limitExceeded:
                        print("Limite de requisições atingido!")
                    default:
                        print("Erro: \(ckError.localizedDescription)")
                    }
                } else {
                    print("Consulta concluída com sucesso")
                }
            }
        }
        
        dataVM.privateDatabase.add(operation)
    }

    // Simulação de múltiplas requisições para atingir o limite
    func simulateRateLimiting() {
        for _ in 0..<50000 {
                self.performCloudKitRequest()
        }
    }
}
 


