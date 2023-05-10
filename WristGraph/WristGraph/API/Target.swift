//
//  Target.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import Foundation
import Moya

public enum Target: Decodable {
    case getGraph(userName: String)
}

extension Target: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    public var path: String {
        switch self {
        case .getGraph:
            return "/graphql"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getGraph:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case .getGraph(let userName):
            let query = """
            query {
              user(login: "\(userName)") {
                contributionsCollection {
                  contributionCalendar {
                    weeks {
                      contributionDays {
                        weekday
                        color
                      }
                    }
                  }
                }
              }
            }
            """
            return .requestParameters(parameters: ["query": query], encoding: JSONEncoding.default)
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .getGraph:
            return ["Authorization": "Bearer \(accessToken)"]
        }
    }
}

