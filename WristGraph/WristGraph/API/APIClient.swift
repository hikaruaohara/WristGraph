//
//  APIClient.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import Foundation
import Moya

public class Request {
    public static let shared = Request()

    private let provider = MoyaProvider<Target>()

    private init() {
    }

    public func getGraph(userName: String) async throws -> [Week] {
        return try await withCheckedThrowingContinuation({ continuation in
            provider.request(.getGraph(userName: userName)) { result in
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(GitHubResponse.self)
                        continuation.resume(returning: decodedResponse.data.user.contributionsCollection.contributionCalendar.weeks)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        })
    }
}
