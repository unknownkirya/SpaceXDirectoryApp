//
//  CrewmateModel]=.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 20.12.2023.
//

import Foundation

// MARK: - CrewmateModel
struct CrewmateModel: Decodable {
    let name, agency: String
    let image: String
    let wikipedia: String
    let launches: [String]
    let status: String
    let id: String
}

typealias CrewmateModels = [CrewmateModel]
