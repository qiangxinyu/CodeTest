//
//  NetworkReachability.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/7.
//

import UIKit
import Alamofire
import SystemConfiguration.CaptiveNetwork

class NetworkStatus {
    static let shared = NetworkStatus()
    
    enum Status {
        case none
        case wifi
        case cellular
        case airplane
        case notAuthority
        
        
        var hasNetwork: Bool {
            self == .wifi || self == .cellular
        }
    }
    
    static var status: Status { shared.status }
    
    private var status = Status.none {
        didSet {
            NotificationCenter.default.post(name: .networkChange, object: nil)
        }
    }
    
    static func regist() {
        var zero = sockaddr()
        zero.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zero.sa_family = sa_family_t(AF_INET)

        guard let reachabilityRef = SCNetworkReachabilityCreateWithAddress(nil, &zero),
        let modeString = CFRunLoopMode.defaultMode?.rawValue else { return }
        
        NotificationCenter.default.addObserver(shared, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        shared.reachabilityRef = reachabilityRef
        SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(),modeString)
    
        shared.checkNetwork()
    }
    
    
    private func checkNetwork() {
        switch NetworkReachabilityManager.default?.status {
        case .notReachable:
            if isUseCellularConnect() || isUseWifiConnect() {
                status = .notAuthority
            } else {
                status = .airplane
            }
            
        case .reachable(let type):
            status = type == .cellular ? Status.cellular : Status.wifi
        default: status = .notAuthority
        }
    }
    
    private var reachabilityRef: SCNetworkReachability?

    
    private func isUseWifiConnect() -> Bool{
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 , let firstAddr = ifaddr else {
            return false
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr,socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        if let wifiIP = address , wifiIP.count > 0 {
            return true
        }
        return false
    }
    
    private func isUseCellularConnect() -> Bool {
        guard let reachabilityRef = reachabilityRef else { return false}
        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(reachabilityRef, &flags){
            return flags.contains(.isWWAN)
        }
        return false
    }
    
    
    @objc private func appDidBecomeActive(){
        checkNetwork()
    }
}

