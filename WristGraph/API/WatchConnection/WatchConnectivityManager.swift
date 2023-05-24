//
//  WatchConnectivityManager.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/12.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, ObservableObject {
    @Published var followers: [String] = []
    @Published var numOfColumns = 16
    @Published var hasHostData = false

    static let shared = WatchConnectivityManager()

    private override init() {
        super.init()

        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func send(followers: [String], numOfColumns: Int) {
        guard WCSession.default.activationState == .activated else {
          return
        }
        #if os(iOS)
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
        #else
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
        #endif

        do {
            try WCSession.default.updateApplicationContext(["followers": followers, "numOfColumns": numOfColumns, "hasHostData": true])
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let followers = applicationContext["followers"] as? [String] {
            DispatchQueue.main.async {
                self.followers = followers
            }
        }

        if let numOfColumns = applicationContext["numOfColumns"] as? Int {
            DispatchQueue.main.async {
                self.numOfColumns = numOfColumns
            }
        }

        if let hasHostData = applicationContext["hasHostData"] as? Bool {
            DispatchQueue.main.async {
                self.hasHostData = hasHostData
            }
        }
    }


    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
