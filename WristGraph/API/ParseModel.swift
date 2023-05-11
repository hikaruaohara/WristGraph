//
//  ParseModel.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import Foundation

public struct GitHubResponse: Decodable {
    public let data: Info
}

public struct Info: Decodable {
    public let user: User
}

public struct User: Decodable {
    public let contributionsCollection: ContributionsCollection
}

public struct ContributionsCollection: Decodable {
    public let contributionCalendar: ContributionCalender
}

public struct ContributionCalender: Decodable {
    public let weeks: [Week]
}

public struct Week: Decodable {
    public let contributionDays: [ContributionDay]
}

public struct ContributionDay: Decodable {
    public let weekday: Int
    public let contributionLevel: String
}
