//
//  MainViewModel.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 08.12.2023.
//

import Foundation
import RxSwift

// MARK: - MissonListViewModelProtocol
protocol MissonListViewModelProtocol {
    func fetchData()
    func numberOfRows() -> Int
}

// MARK: - Struct
struct Mission {
    var icon: String?
    var name: String
    var firstStageReuses: Int
    var success: String
    var dateString: String
    var date: Date
}

// MARK: - MainViewModel
final class MissionListViewModel: MissonListViewModelProtocol {
    
    // MARK: - Public properties
    let reloadTable = PublishSubject<Void>()
    let repository: MissionListRepository
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    private let baseUseCase = BaseUseCase()
    private let missionListUseCase = MissionListUseCase()
    private var displayItems: [Mission] = []
    
    // MARK: - Life cycle
    init(repository: MissionListRepository) {
        self.repository = repository
        
        fetchData()
    }
    
    // MARK: - flow
    func fetchData() {
        repository.get()
            .subscribe(onSuccess: { [weak self] in
                if let exampleModel = self?.baseUseCase.filterModel(exampleModel: $0) {
                    self?.displayItems = self?.missionListUseCase.prepareItems(exampleModel: exampleModel) ?? []
                    self?.reloadTable.onNext(())
                }
            })
            .disposed(by: bag)
    }
    
    func numberOfRows() -> Int {
        displayItems.count
    }
    
    func recieveMission(indexPath: IndexPath) -> Mission {
        return displayItems[indexPath.row]
    }
}
