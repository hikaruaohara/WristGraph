//
//  ContentView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @AppStorage("numOfColumns") private var numOfColumns = 16
    @State private var followers = UserDefaults.standard.stringArray(forKey: "followers") ?? [String]()
    @State private var showSheet = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationView {
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
                SheetView(followers: $followers, showSheet: $showSheet)
            }
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    saveAndSend(followers: followers, numOfColumns: numOfColumns)
                }
            }
        }
    }

    func saveAndSend(followers: [String], numOfColumns: Int) {
        UserDefaults.standard.set(followers, forKey: "followers")
        connectivityManager.send(followers: followers, numOfColumns: numOfColumns)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
