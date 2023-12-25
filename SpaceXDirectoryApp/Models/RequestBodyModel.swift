//
//  RequestBodyModel.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 25.12.2023.
//

import Foundation

struct RequestBodyModel: Codable {
    let query: Query
    let options: Options
}

struct Query: Codable {
    let dateUtc: DateUtc
}

struct Options: Codable {
    let sort: Sort
    let page: Int
    let limit: Int
}

struct DateUtc: Codable {
    let gte: String
    
    enum CodingKeys: String, CodingKey {
        case gte = "$gte"
    }
}

struct Sort: Codable {
    let dateUtc: String
}
