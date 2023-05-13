//
//  SheetView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/13.
//

import SwiftUI

struct SheetView: View {
    @Binding var followers: [String]
    @Binding var showSheet: Bool
    @Binding var numOfColumns: Int
    @State private var showAlert = false
    @State private var newName = ""
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Number of columns")) {
                        Stepper(value: $numOfColumns, in: 16...53, step: 1) {
                            Text("\(numOfColumns)")
                        }
                    }
                    .textCase(.none)

                    Section(header: Text("Contribution graph list")) {
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
                            showAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add")
                            }
                            .foregroundColor(.blue)
                        }
                        .alert("Add an github account", isPresented: $showAlert) {
                            TextField("Enter a username", text: $newName)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)

                            Button(role: .cancel) {
                                newName = ""
                                showAlert = false
                            } label: {
                                Text("Cancel")
                            }

                            Button() {
                                addFollowers()
                                showAlert = false
                            } label: {
                                Text("Add")
                            }
                        }
                    }
                    .textCase(.none)
                }
                .listStyle(.insetGrouped)
                .onDisappear {
                    saveAndSend()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showSheet = false
                        } label: {
                            Text("Done")
                                .bold()
                        }
                    }
                }
            }
        }
    }

    func saveAndSend() {
        UserDefaults.standard.set(followers, forKey: "followers")
        UserDefaults.standard.set(numOfColumns, forKey: "numOfColumns")
        connectivityManager.send(followers: followers, numOfColumns: numOfColumns)
    }

    func addFollowers() {
        if !followers.contains(newName) && !newName.isEmpty {
            followers.append(newName)
        }
        newName = ""
    }
}

struct SheetView_Previews: PreviewProvider {
    @State private static var followers = ["hikaruaohara", "tomota8686", "znnz0"]
    @State private static var showSheet = true
    @State private static var numOfColumns = 16

    static var previews: some View {
        SheetView(followers: $followers, showSheet: $showSheet, numOfColumns: $numOfColumns)
            .environment(\.colorScheme, .dark)
    }
}
