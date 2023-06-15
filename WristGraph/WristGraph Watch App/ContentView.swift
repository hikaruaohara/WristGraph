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
    @EnvironmentObject private var model: Model
    @Environment(\.scenePhase) private var scenePhase

    init() {
        loadUserDefaults()
    }

    var body: some View {
        ScrollView {
            if model.followers.isEmpty {
                VStack {
                    Text("Add GitHub accounts on the iPhone app.")
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
            } else {
                VStack(alignment: .leading) {
                    ForEach(model.followers, id: \.self) { follower in
                        Text(follower)
                            .bold()
                        GraphView(graphViewModel: GraphViewModel(userName: follower))
                        Divider()
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                loadUserDefaults()
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    func loadUserDefaults() {
        if connectivityManager.hasHostData {
            model.numOfCols = connectivityManager.numOfCols
            model.followers = connectivityManager.followers
            sharedUserDefaults.set(model.numOfCols, forKey: "numOfCols")
            sharedUserDefaults.set(model.followers, forKey: "followers")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Model())
    }
}
