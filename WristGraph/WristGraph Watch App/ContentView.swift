//
//  ContentView.swift
//  WristGraph Watch App
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    private let sharedUserDefaults = UserDefaults(suiteName: "group.com.hikaruaohara.WristGraph")!
    @State private var followers = [String]()
    @State private var numOfColumns = 16
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @Environment(\.scenePhase) private var scenePhase

    init() {
        sharedUserDefaults.register(defaults: ["followers": [String](), "numOfColumns": 16])
        loadUserDefaults()
    }

    var body: some View {
        ScrollView {
            if followers.isEmpty {
                VStack {
                    Text("Add GitHub accounts on the iPhone app.")
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
            } else {
                VStack(alignment: .leading) {
                    ForEach(followers, id: \.self) { follower in
                        Text(follower)
                            .bold()
                        GraphView(userName: follower, numOfColumns: sharedUserDefaults.integer(forKey: "numOfColumns"))
                        Divider()
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                loadUserDefaults()
            }
        }
    }

    func loadUserDefaults() {
        if connectivityManager.hasHostData {
            sharedUserDefaults.set(connectivityManager.followers, forKey: "followers")
            sharedUserDefaults.set(connectivityManager.numOfColumns, forKey: "numOfColumns")
        }

        followers = sharedUserDefaults.stringArray(forKey: "followers")!
        numOfColumns = sharedUserDefaults.integer(forKey: "numOfColumns")

        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
