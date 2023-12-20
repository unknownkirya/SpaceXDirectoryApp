//
//  MissionDetailRepository.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 20.12.2023.
//

import Foundation
import RxSwift
import RxMoya
import Moya

// MARK: - MissionListRepository
class MissionDetailRepository: BaseRepository {

    typealias T = CrewmateModels
    
    func get() -> Single<CrewmateModels> {
        fatalError("Must be overriden!")
    }
    
}

// MARK: - MissionDetailRepositoryImpl
final class MissionDetailRepositoryImpl: MissionDetailRepository {
    
    // MARK: Private properties
    private let bag = DisposeBag()
    private let baseUseCase = BaseUseCase()
    private let provider = MoyaProvider<API>()
    private let decoder = JSONDecoder()
    
    // MARK: - Life Cycle
    override init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Overrided functions
    override func get() -> Single<CrewmateModels> {
        provider.rx
            .request(.fetchCrewmates)
            .filterSuccessfulStatusCodes()
            .map(CrewmateModels.self, using: decoder)
    }
}
