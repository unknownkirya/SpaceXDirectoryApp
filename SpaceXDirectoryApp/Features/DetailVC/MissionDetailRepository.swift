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
protocol MissionDetailRepository {
    
    func get() -> Single<CrewmateModels>
    
}

// MARK: - MissionDetailRepositoryImpl
final class MissionDetailRepositoryImpl: MissionDetailRepository {
    
    // MARK: Private properties
    private let bag = DisposeBag()
    private let provider = MoyaProvider<API>()
    private let decoder = JSONDecoder()
    
    // MARK: - Life Cycle
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public function
    func get() -> Single<CrewmateModels> {
        provider.rx
            .request(.fetchCrewmates)
            .filterSuccessfulStatusCodes()
            .map(CrewmateModels.self, using: decoder)
    }
}
