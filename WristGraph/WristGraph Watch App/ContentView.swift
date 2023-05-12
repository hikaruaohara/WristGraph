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
        ScrollView {
            VStack {
                ForEach(connectivityManager.followers, id: \.self) { follower in
                    ListItem(userName: follower)
                    Divider()
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
