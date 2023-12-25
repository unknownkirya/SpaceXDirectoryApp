//
//  MissionModel.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 08.12.2023.
//
import Foundation

// MARK: - QueryiesModel
struct QueryiesModel: Codable {
    let docs: MissionModels
    let page: Int
}

// MARK: - MissionElement
struct MissionElement: Codable {
    let links: Links
    let success: Bool?
    let details: String?
    let crew: [String]
    let name, dateUtc: String
    let dateLocal: Date
    let cores: [Core]
}

// MARK: - Core
struct Core: Codable {
    let core: String?
    let flight: Int?
}

// MARK: - Links
struct Links: Codable {
    let patch: Patch
}

// MARK: - Patch
struct Patch: Codable {
    let small, large: String?
}

// MARK: - MissionModels typealias
typealias MissionModels = [MissionElement]
