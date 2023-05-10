//
//  ContentView.swift
//  WristGraph Watch App
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    @State private var followers = UserDefaults.standard.stringArray(forKey: "followers") ?? [String]()
    var body: some View {
        GeometryReader { geometry in
            ForEach(followers, id: \.self) { follower in
                NavigationLink(destination: GraphView(userName: follower)) {
                    ListItem(userName: follower)
                        .frame(height: 41 * geometry.size.width / 70)
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
