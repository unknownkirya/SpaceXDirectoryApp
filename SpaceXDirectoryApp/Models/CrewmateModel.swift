//
//  CrewmateModel]=.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 20.12.2023.
//

import Foundation

// MARK: - CrewmateModel
struct CrewmateModel: Decodable {
    let name, agency, status: String
    let id: String
}

// MARK: - CrewmateModels typealias
typealias CrewmateModels = [CrewmateModel]
