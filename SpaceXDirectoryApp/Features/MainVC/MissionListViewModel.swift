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
    
    var reloadTable: PublishSubject<Void> { get }
    var repository: MissionListRepository { get }
    
    func fetchData(page: Int)
    func numberOfRows() -> Int
    func recieveMission(indexPath: IndexPath) -> Mission
}

// MARK: - Struct
struct Mission {
    let icon: String?
    let name: String
    let firstStageReuses: Int
    let success: String
    let dateString: String
    let date: Date
}

// MARK: - MainViewModel
final class MissionListViewModel: MissonListViewModelProtocol {
    
    // MARK: - Public properties
    let reloadTable = PublishSubject<Void>()
    let repository: MissionListRepository
    
    // MARK: - Private properties
    private let bag = DisposeBag()
    private let missionListUseCase = MissionListUseCase()
    private var displayItems: [Mission] = []
    
    // MARK: - Life cycle
    init(repository: MissionListRepository) {
        self.repository = repository
        
        fetchData(page: 1)
    }
    
    // MARK: - Public functions
    func fetchData(page: Int) {
        let query: Query = Query(dateUtc: DateUtc(gte: "2021-01-01T00:00:00.000Z"))
        let options: Options = Options(sort: Sort(dateUtc: "desc"), page: page, limit: 10)
        let requestBodyModel: RequestBodyModel = RequestBodyModel(query: query, options: options)
        
        repository.get(requestBodyModel: requestBodyModel)
            .subscribe(onSuccess: { [weak self] in
                self?.displayItems.append(contentsOf: self?.missionListUseCase.prepareItems(exampleModel: $0.docs) ?? [])
                self?.reloadTable.onNext(())
            })
            .disposed(by: bag)
    }
    
    func numberOfRows() -> Int {
        displayItems.count
    }
    
    func recieveMission(indexPath: IndexPath) -> Mission {
        displayItems[indexPath.row]
    }
}
