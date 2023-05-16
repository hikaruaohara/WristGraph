//
//  ContentView.swift
//  WristGraph Watch App
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    private let sharedUserDefaults = UserDefaults(suiteName: "N38H3ZBTB2.group.com.hikaruaohara.WristGraph")!
    @AppStorage("numOfColumns") private var numOfColumns = 16
    @State private var followers = [String]()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        loadUserDefaults()
    }

    var body: some View {
        if followers.isEmpty {
            VStack {
                ProgressView()
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
        if let defaultFollowers = sharedUserDefaults.stringArray(forKey: "followers") {
            followers = defaultFollowers
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
