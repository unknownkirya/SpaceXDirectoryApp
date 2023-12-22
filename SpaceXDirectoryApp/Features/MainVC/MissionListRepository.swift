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

// MARK: - MissionListRepository
protocol MissionListRepository {
    
    typealias T = MissionModels
    var missionCache: MissionModels? { get }
    
    func get() -> Single<MissionModels> 
}

// MARK: - MissionListRepositoryImpl
final class MissionListRepositoryImpl: MissionListRepository {
    var missionCache: MissionModels?
    
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    private let baseUseCase = BaseUseCase()
    private let provider = MoyaProvider<API>()
    private let decoder = JSONDecoder()
    
    // MARK: - Life Cycle
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Overrided functions
    func get() -> Single<MissionModels> {
        provider.rx
            .request(.fetchMissions)
            .filterSuccessfulStatusCodes()
            .map(MissionModels.self, using: decoder)
            .do(onSuccess: { [weak self] result in
                self?.missionCache = self?.baseUseCase.filterModel(exampleModel: result)
            })
    }
}
