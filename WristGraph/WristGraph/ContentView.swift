//
//  ContentView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @State private var followers = UserDefaults.standard.stringArray(forKey: "followers") ?? [String]()
    @State private var numOfColumns = UserDefaults.standard.integer(forKey: "numOfColumns")
    @State private var showSheet = false
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationView {
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
            .navigationTitle("Contribution Graphs")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                SheetView(followers: $followers, showSheet: $showSheet, numOfColumns: $numOfColumns)
            }

        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                saveAndSend()
            }
        }
    }

    func saveAndSend() {
        UserDefaults.standard.set(followers, forKey: "followers")
        UserDefaults.standard.set(numOfColumns, forKey: "numOfColumns")
        connectivityManager.send(followers: followers, numOfColumns: numOfColumns)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
