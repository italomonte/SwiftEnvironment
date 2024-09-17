import Foundation
import CloudKit

struct Photo: Hashable {
    var title: String
    var image: CKAsset
    let record: CKRecord
}
