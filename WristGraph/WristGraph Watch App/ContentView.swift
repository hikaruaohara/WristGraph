//
//  ContentView.swift
//  WristGraph Watch App
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @AppStorage("numOfColumns") private var numOfColumns = 16
    @State private var followers = UserDefaults(suiteName: "N38H3ZBTB2.group.com.hikaruaohara.WristGraph")!.stringArray(forKey: "followers") ?? [String]()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        loadUserDefaults()
    }

    var body: some View {
        ScrollView {
            if followers.isEmpty {
                VStack {
                    Text("Add GitHub accounts")
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
            } else {
                VStack(alignment: .leading) {
                    ForEach(followers, id: \.self) { follower in
                        Text(follower)
                            .bold()
                        GraphView(userName: follower, numOfColumns: numOfColumns)
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
        numOfColumns = connectivityManager.numOfColumns
        followers = connectivityManager.followers

        UserDefaults(suiteName: "N38H3ZBTB2.group.com.hikaruaohara.WristGraph")!.set(followers, forKey: "followers")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
