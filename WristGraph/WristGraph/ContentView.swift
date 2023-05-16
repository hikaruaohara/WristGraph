//
//  ContentView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    private let sharedUserDefaults = UserDefaults(suiteName: "N38H3ZBTB2.group.com.hikaruaohara.WristGraph")!
    @AppStorage("numOfColumns") private var numOfColumns = 16
    @State private var followers = [String]()
    @State private var showSheet = false
    @State private var text = ""
    @Environment(\.scenePhase) private var scenePhase

    init() {
        if let defaultFollowers = sharedUserDefaults.stringArray(forKey: "followers") {
            followers = defaultFollowers
        }
        text = "no follower"
    }

    var body: some View {
        NavigationView {
            ScrollView {
                if followers.isEmpty {
                    VStack {
                        Text(text)
                        Text("Add GitHub accounts")
                            .foregroundColor(.gray)
                            .opacity(0.5)
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text(text)
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UserDefaults {
    enum Keys: String {
        case follwers
        case numOfColumns
    }
}
