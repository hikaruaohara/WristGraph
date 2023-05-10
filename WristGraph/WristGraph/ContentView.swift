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

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                List {
                    ForEach(followers, id: \.self) { follower in
                        ListItem(userName: follower)
                            .frame(height: 41 * geometry.size.width / 90)
                    }
                    .onMove(perform: { index, destination in
                        followers.move(fromOffsets: index, toOffset: destination)
                        UserDefaults.standard.set(followers, forKey: "followers")
                    })
                    .onDelete { index in
                        followers.remove(atOffsets: index)
                        UserDefaults.standard.set(followers, forKey: "followers")
                    }
                }
                .navigationTitle("Contribution")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isAlertEnabled = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                    }
                }
                .alert("Add an github account", isPresented: $isAlertEnabled) {
                    TextField("Enter a github account username", text: $newName)
                        .disableAutocorrection(true)

                    Button("Add") {
                        followers.append(newName)
                        UserDefaults.standard.set(followers, forKey: "followers")
                        newName = ""
                    }

                    Button("Cancel", role: .cancel) {
                        newName = ""
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
