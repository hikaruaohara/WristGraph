//
//  ContentView.swift
//  WristGraph Watch App
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("numOfColumns") private var numOfColumns = 16
    @State private var followers = UserDefaults(suiteName: "N38H3ZBTB2.group.com.hikaruaohara.WristGraph")!.stringArray(forKey: "followers") ?? [String]()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        loadUserDefaults()
    }

    var body: some View {
        if followers.isEmpty {
            VStack {
                ProgressView()
                Button("load") {
                    loadUserDefaults()
                }
            }
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(followers, id: \.self) { follower in
                        Text(follower)
                            .bold()
                        GraphView(userName: follower, numOfColumns: numOfColumns)
                        Divider()
                    }
                    Button("load") {
                        loadUserDefaults()
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
    }

    func loadUserDefaults() {
        if let defaultFollowers = UserDefaults(suiteName: "N38H3ZBTB2.group.com.hikaruaohara.WristGraph")!.stringArray(forKey: "followers") {
            followers = defaultFollowers
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
