//
//  APIClient.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import Foundation

class APIClient {
    let url = URL(string: "https://api.github.com/graphql")!

    func request() async {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            print(data)
        } catch {
            print(error)
        }
    }
}
