import SwiftUI

private struct Mac: Hashable {
    let serialNumber: String
    let capacity: Int
    let ramMemory: Int
    var macOSVersion: Float
}

struct WithHashable: View {
    
    private let MacList: [Mac] = [
        Mac(serialNumber: "A1234", capacity: 64, ramMemory: 16, macOSVersion: 17.4),
        Mac(serialNumber: "B5678", capacity: 128, ramMemory: 32, macOSVersion: 17.2),
        Mac(serialNumber: "B3458", capacity: 1024, ramMemory: 32, macOSVersion: 17.2),
        Mac(serialNumber: "D2658", capacity: 256, ramMemory: 16, macOSVersion: 17.2)
    ]
    
    var body: some View {
        VStack {
            List{
                ForEach(MacList, id: \.self) { mac in
                    HStack{
                        Image(systemName: "macbook")
                       
                        Text("Capacity: \(String(mac.capacity))")
                            .padding()
                    }
                }
                
                
            }
        }
    }
}


func getData(_ index: Int) {

}

getData(
