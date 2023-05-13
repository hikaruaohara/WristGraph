//
//  ContentView.swift
//  WristGraph Watch App
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared

    var body: some View {
        if connectivityManager.followers.isEmpty {
            VStack {
                ProgressView()
            }
        } else {
            ScrollView {
                VStack {
                    ForEach(connectivityManager.followers, id: \.self) { follower in
                        Text(follower)
                            .bold()
                        GraphView(userName: follower, numOfColumns: connectivityManager.numOfColumns)
                        Divider()
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
