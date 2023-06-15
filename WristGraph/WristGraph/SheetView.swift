//
//  SheetView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/13.
//

import SwiftUI

struct SheetView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @Binding var showSheet: Bool
    @State private var showAlert = false
    @State private var newName = ""
    @EnvironmentObject private var model: Model

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Number of columns")) {
                        Stepper(value: $model.numOfCols, in: 16...53, step: 1) {
                            Text("\(model.numOfCols)")
                        }
                    }
                    .textCase(.none)

                    Section(header: Text("Contribution graph list")) {
                        ForEach(model.followers, id: \.self) { follower in
                            Text(follower)
                        }
                        .onMove { index, destination in
                            model.followers.move(fromOffsets: index, toOffset: destination)
                        }
                        .onDelete { index in
                            model.followers.remove(atOffsets: index)
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
                                addFollowers(newFollowerName: newName)
                                newName = ""
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
        UserDefaults.standard.set(model.followers, forKey: "followers")
        UserDefaults.standard.set(model.numOfCols, forKey: "numOfCols")
        connectivityManager.send(followers: model.followers, numOfCols: model.numOfCols)
    }

    func addFollowers(newFollowerName: String) {
        let name = newFollowerName.trimmingCharacters(in: .whitespaces)

        if !model.followers.contains(name) && !name.isEmpty {
            model.followers.append(name)
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    @State private static var showSheet = true

    static var previews: some View {
        SheetView(showSheet: $showSheet)
    }
}
