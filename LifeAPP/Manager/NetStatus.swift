//
//  ReachabilityManager.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/8.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import Network

class NetStatus {
    
    // MARK: - Properties
    
    static let shared = NetStatus()
    let monitor = NWPathMonitor()
    func isConnect() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("connected")
            } else {
                print("no connection")
                
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
}
