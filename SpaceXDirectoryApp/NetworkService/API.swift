//
//  API.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 11.12.2023.
//

import Foundation
import Moya

// MARK: - API Enum
enum API {
    case fetchMissions(parameters: RequestBodyModel)
    case fetchCrewmates
}

// MARK: - Target type
extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.kUrl) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchMissions:
            return "launches/query"
        case .fetchCrewmates:
            return "crew"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMissions:
            return .post
        case .fetchCrewmates:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchMissions(parameters):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return .requestCustomJSONEncodable(parameters, encoder: encoder)
        case .fetchCrewmates:
            return .requestPlain
        }
    }
        
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
