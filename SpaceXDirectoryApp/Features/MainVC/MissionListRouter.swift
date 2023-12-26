//
//  MainRouter.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 11.12.2023.
//

import UIKit
import RxSwift

// MARK: - MissonsLIstRouter
final class MissionListRouter: BaseRouter<MissionListRouter.Route> {
    
    // MARK: - Route enum
    enum Route {
        case showDetail(parameters: MissionElement)
    }
    
    // MARK: - Overrided methods
    override func prepareTransition(for route: Route,
                                    with result: PublishSubject<Any?>?) -> NavigationTransition?{
        switch route {
        case let .showDetail(parameters):
            let vm = MissionDetailViewModel(displayItem: parameters)
            let missionDetailVC = MissionDetailViewController(viewModel: vm)
            
            return .push(vc: missionDetailVC)
        }
    }
}
