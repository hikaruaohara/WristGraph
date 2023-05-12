//
//  ContentView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @State private var followers = UserDefaults.standard.stringArray(forKey: "followers") ?? [String]()
    @State private var newName: String = ""
    @State private var isAlertEnabled = false
    @State private var isSheetEnabled = false
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @Environment(\.scenePhase) private var scenePhase

    init() {
        saveAndSend()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(followers, id: \.self) { follower in
                        ListItem(userName: follower)
                        Divider()
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Contribution")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSheetEnabled = true
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
            .sheet(isPresented: $isSheetEnabled) {
                NavigationView {
                    List {
                        ForEach(followers, id: \.self) { follower in
                            Text(follower)
                        }
                        .onMove { index, destination in
                            followers.move(fromOffsets: index, toOffset: destination)
                        }
                        .onDelete { index in
                            followers.remove(atOffsets: index)
                        }

                        Button {
                            isAlertEnabled = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add")
                                    .foregroundColor(.blue)
                            }
                        }
                        .alert("Add an github account", isPresented: $isAlertEnabled) {
                            TextField("Enter a username", text: $newName)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)

                            Button(role: .cancel) {
                                newName = ""
                                isAlertEnabled = false
                            } label: {
                                Text("Cancel")
                            }

                            Button() {
                                addFollowers()
                                isAlertEnabled = false
                            } label: {
                                Text("Add")
                            }
                        }
                    }
                    .onDisappear {
                        saveAndSend()
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                isSheetEnabled = false
                            } label: {
                                Text("Done")
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: scenePhase) { _ in
            saveAndSend()
        }
    }

    func saveAndSend() {
        UserDefaults.standard.set(followers, forKey: "followers")
        connectivityManager.send(followers)
    }

    func addFollowers() {
        if !followers.contains(newName) && !newName.isEmpty {
            followers.append(newName)
        }
        newName = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
