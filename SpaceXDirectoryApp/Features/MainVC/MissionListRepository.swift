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
class MissionListRepository: BaseRepository {
    
    typealias T = MissionModels
    var missionCache: MissionModels?
    
    func get() -> Single<MissionModels> {
        fatalError("Must be overriden!")
    }
    
    func clearCache(cacheElement: inout MissionModels?) {
        cacheElement = nil
    }
    
}

// MARK: - MissionListRepositoryImpl
final class MissionListRepositoryImpl: MissionListRepository {
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    private let baseUseCase = BaseUseCase()
    private let provider = MoyaProvider<API>()
    private let decoder = JSONDecoder()
    
    // MARK: - Life Cycle
    override init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Overrided functions
    override func get() -> Single<MissionModels> {
        provider.rx
            .request(.fetchMissions)
            .filterSuccessfulStatusCodes()
            .map(MissionModels.self, using: decoder)
            .do(onSuccess: { [weak self] result in
                self?.missionCache = self?.baseUseCase.filterModel(exampleModel: result)
            })
    }
}
