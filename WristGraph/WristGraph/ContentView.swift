//
//  ContentView.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button {
                Task {
                    do {
                        let weeks = try await Request.shared.getGraph(userName: "hikaruaohara")
                        for week in weeks {
                            for day in week.contributionDays {
                                print(day.weekday)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Call API")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
