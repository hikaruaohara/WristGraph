//
//  ContentView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = false
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @State private var showSheet = false
    @EnvironmentObject private var model: Model
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationView {
            Group {
                if model.followers.isEmpty {
                    Text("Add GitHub accounts.")
                        .foregroundColor(.gray)
                        .opacity(0.5)
                } else {
                    List {
                        if !isLoading {
                            ForEach(model.graphViewModels.indices, id: \.self) { index in
                                VStack(alignment: .leading) {
                                    Text(model.followers[index])
                                        .bold()
                                    GraphView(graphViewModel: model.graphViewModels[index])
                                }
                            }
                            .onMove { index, destination in
                                model.followers.move(fromOffsets: index, toOffset: destination)
                                model.graphViewModels.move(fromOffsets: index, toOffset: destination)
                            }
                            .onDelete { index in
                                model.followers.remove(atOffsets: index)
                                model.graphViewModels.remove(atOffsets: index)
                            }
                        }
                    }
                    .refreshable {
                        await reload()
                    }
                }
            }
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
            .onChange(of: showSheet, perform: { newValue in
                Task {
                    await reload()
                }
            })
            .onChange(of: scenePhase) { phase in
                Task {
                    if phase == .active {
                        saveAndSend()
                    }
                }
            }
        }
    }

    func reload() async {
        isLoading = true
        for graphViewModel in model.graphViewModels {
            await graphViewModel.fetchData()
        }
        isLoading = false
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
