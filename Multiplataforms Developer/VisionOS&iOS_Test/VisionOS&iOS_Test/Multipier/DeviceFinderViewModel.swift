//
//  vm.swift
//  VisionOS&iOS_Test
//
//  Created by Italo Guilherme Monte on 24/07/24.
//

import Foundation
import MultipeerConnectivity
import CoreLocation

class DeviceFinderViewModel: NSObject, ObservableObject {
    
    private let browser: MCNearbyServiceBrowser
    private let advertiser: MCNearbyServiceAdvertiser
    private let session: MCSession
    private let serviceType = "nearby-devices"
    @Published var peers: [PeerDevice] = []
    
    @Published var isAdvertised: Bool = false {
        didSet {
            isAdvertised ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    
    var locationManager: CLLocationManager
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0

    @Published var log: String = ""
    
    override init() {
        
        let peer = MCPeerID(displayName: UIDevice.current.name)
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        advertiser = MCNearbyServiceAdvertiser(
                    peer: peer,
                    discoveryInfo: nil,
                    serviceType: serviceType
                )
        
        session = MCSession(peer: peer)
        locationManager = CLLocationManager()

        super.init()
        
        locationManager.delegate = self
        browser.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
    }

    func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
    func finishBrowsing() {
        browser.stopBrowsingForPeers()
    }
}

extension DeviceFinderViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers.append(PeerDevice(peerId: peerID))
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0.peerId == peerID })
    }
}

extension DeviceFinderViewModel: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            log = "Location authorization not determined"
        case .restricted:
            log = "Location authorization restricted"
        case .denied:
            log = "Location authorization denied"
        case .authorizedAlways:
            manager.requestLocation()
            log = "Location authorization always granted"
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            log = "Location authorization when in use granted"
        @unknown default:
            log = "Unknown authorization status"
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { location in
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }
}


struct PeerDevice: Identifiable, Hashable {
    let id = UUID()
    let peerId: MCPeerID
}

