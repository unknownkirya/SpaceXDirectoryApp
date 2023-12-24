//
//  MissionDetailViewModel.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 18.12.2023.
//

import Foundation
import RxSwift

// MARK: - MissionDetailViewModelProtocol
protocol MissionDetailViewModelProtocol {
    
}

// MARK: - MissionDetail struct
struct MissionDetail {
    let icon: String?
    let name: String
    let firstStageReuses: Int
    let status: String
    let dateString: String
    let details: String
    let crew: [String]
}

struct Crewmate {
    let name: String
    let agency: String
    let status: String
}

// MARK: - MissionDetailViewModel
final class MissionDetailViewModel: MissionDetailViewModelProtocol {
    
    // MARK: - Public Property
    let reloadTable = PublishSubject<Void>()
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    private let useCase = MissionDetailUseCase()
    private let repository = MissionDetailRepositoryImpl()
    private var missionDisplayItem: MissionDetail
    private var crewmatesDisplayItems: [Crewmate] = []
    
    // MARK: - Life cycle
    init(displayItem: MissionElement) {
        missionDisplayItem = useCase.prepareMissionItem(parameters: displayItem)
        
        fetchData()
    }
    
    func fetchData() {
        repository.get()
            .map { crewmates in
                crewmates.filter { [weak self] crewmate in
                    guard let self else { return false }
                    
                    return self.missionDisplayItem.crew.contains(crewmate.id)
                }
            }
            .subscribe(onSuccess: { [weak self] in
                guard let self else { return }
                self.crewmatesDisplayItems = self.useCase.prepareCrewmateItem(parameters: $0)
                self.reloadTable.onNext(())
            })
            .disposed(by: bag)
    }
    
    // MARK: - Public properties
    func getDisplayItem() -> MissionDetail {
        missionDisplayItem
    }
    
    func numberOfRowsOfCrew() -> Int {
        crewmatesDisplayItems.count
    }
    
    func crewmateForId(for indexPath: IndexPath) -> Crewmate {
        crewmatesDisplayItems[indexPath.row]
    }
}
