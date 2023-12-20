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
    var icon: String?
    var name: String
    var firstStageReuses: Int
    var status: String
    var dateString: String
    var details: String
    var crew: [String]
}

struct Crewmate {
    var name: String
    var agency: String
    var status: String
}

// MARK: - MissionDetailViewModel
final class MissionDetailViewModel: MissionDetailViewModelProtocol {
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    private let reloadTable = PublishSubject<Void>()
    private let useCase = MissionDetailUseCase()
    private let repository = MissionDetailRepositoryImpl()
    private var missionDisplayItem: MissionDetail
    private var crewmatesDisplayItems: [String: Crewmate] = [:]
    
    // MARK: - Life cycle
    init(displayItem: MissionElement) {
        self.missionDisplayItem = useCase.prepareMissionItem(parameters: displayItem)
        
        self.fetchData()
    }
    
    func fetchData() {
        repository.get()
            .subscribe(onSuccess: { [weak self] in
                self?.crewmatesDisplayItems = self?.useCase.prepareCrewmateItem(parameters: $0) ?? [:]
                //print($0)
                self?.reloadTable.onNext(())
            })
            .disposed(by: bag)
    }
    
    // MARK: - Public properties
    func getDisplayItem() -> MissionDetail {
        return missionDisplayItem
    }
    
    func numberOfRowsOfCrew() -> Int {
        missionDisplayItem.crew.count
    }
    
    func crewmateForId(id: String) -> Crewmate {
        print(crewmatesDisplayItems)
        return crewmatesDisplayItems[id] ?? Crewmate(name: "", agency: "", status: "")
    }
}
