//
//  MissionListRepository.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 18.12.2023.
//

import Foundation
import RxSwift
import RxMoya
import Moya

// MARK: - MissionListRepository protocol
protocol MissionListRepository {
    
    typealias T = MissionModels
    var missionCache: MissionModels { get }
    
    func get(requestBodyModel: RequestBodyModel) -> Single<QueryiesModel> 
}

// MARK: - MissionListRepositoryImpl
final class MissionListRepositoryImpl: MissionListRepository {
    
    // MARK: - Public propety
    var missionCache: MissionModels = []
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    private let provider = MoyaProvider<API>()
    private let decoder = JSONDecoder()
    
    // MARK: - Life Cycle
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Public methods
    func get(requestBodyModel: RequestBodyModel) -> Single<QueryiesModel> {
        provider.rx
            .request(.fetchMissions(parameters: requestBodyModel))
            .filterSuccessfulStatusCodes()
            .map(QueryiesModel.self, using: decoder)
            .do(onSuccess: { [weak self] in
                self?.missionCache.append(contentsOf: $0.docs)
            })
    }
}
