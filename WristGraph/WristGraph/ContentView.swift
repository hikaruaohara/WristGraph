//
//  ContentView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @State private var showSheet = false
    @EnvironmentObject private var model: Model
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationView {
            ScrollView {
                if model.followers.isEmpty {
                    VStack {
                        Text("Add GitHub accounts.")
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
                SheetView(showSheet: $showSheet)
            }
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    saveAndSend()
                }
            }
        }
    }

    func saveAndSend() {
        UserDefaults.standard.set(model.followers, forKey: "followers")
        UserDefaults.standard.set(model.numOfCols, forKey: "numOfCols")
        connectivityManager.send(followers: model.followers, numOfCols: model.numOfCols)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Model())
    }
}
