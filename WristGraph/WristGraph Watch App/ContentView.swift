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
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @Environment(\.scenePhase) private var scenePhase

    init() {
        loadUserDefaults()
    }

    var body: some View {
        ScrollView {
            if connectivityManager.followers.isEmpty {
                VStack {
                    Text("Add GitHub accounts on the iPhone app.")
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
            } else {
                VStack(alignment: .leading) {
                    ForEach(connectivityManager.followers, id: \.self) { follower in
                        Text(follower)
                            .bold()
                        GraphView(userName: follower, numOfColumns: connectivityManager.numOfColumns)
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
        sharedUserDefaults.set(connectivityManager.followers, forKey: "followers")
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
