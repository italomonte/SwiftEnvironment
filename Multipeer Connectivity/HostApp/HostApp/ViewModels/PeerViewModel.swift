
import Foundation
import MultipeerConnectivity

class PeerViewModel: NSObject, ObservableObject {
    
    let peerId: MCPeerID
    var hostId: MCPeerID?
    let session: MCSession
    let advertiser: MCNearbyServiceAdvertiser
    
    var invitationHandler: ((Bool, MCSession?) -> Void)?
    var invitationPeerName = ""

    @Published var showingPermissionRequesttt = false
    
    var permissionRequest: PermitionRequest?
    
    var isAdvertising = false {
        didSet {
            isAdvertising ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    
    var message: String = ""
    @Published var messages: [String] = []
    
    let messagePublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    override init() {
        self.peerId = MCPeerID(displayName: UIDevice.current.name)
        
        self.session = MCSession(peer: peerId)
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: "nearby-devices")
        
        super.init()
        
        session.delegate = self
        advertiser.delegate = self
        
        messagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.messages.append($0)
            }
            .store(in: &subscriptions)
    }
    
    func respondToInvitation(accept: Bool) {
            if let handler = invitationHandler {
                handler(accept, accept ? session : nil)
            }
        }
    
}

extension PeerViewModel: MCSessionDelegate {
    
    //  É chamado sempre que o estado de conexão de um peer na sessão muda. Isso ocorre quando um peer se conecta, desconecta ou tenta se conectar.
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    // Esse método é chamado quando você recebe um pacote de dados (tipo Data) de outro peer.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceive bytes \(data.count) bytes")
        guard let message = String(data: data, encoding: .utf8) else {
            return
        }
        messagePublisher.send(message)
        
    }

    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
}

extension PeerViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        self.invitationPeerName = peerID.displayName
        self.showingPermissionRequest = true

        permissionRequest = PermitionRequest(
            peerId: peerID,
            onRequest: { [weak self] permission in
                invitationHandler(permission, permission ? self?.session : nil)
            }
        )
        hostId = peerId
    }
    
   
}

struct PermitionRequest: Identifiable {
    let id = UUID()
    let peerId: MCPeerID
    let onRequest: (Bool) -> Void
}


