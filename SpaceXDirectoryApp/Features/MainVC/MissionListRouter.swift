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
  
  enum Route {
      case showDetail(parameters: MissionElement) // parameters: MissionDetailParameters
  }
  
    // MARK: - Overrided methods
    override func prepareTransition(for route: Route,
                                    with result: PublishSubject<Any?>?) -> NavigationTransition?{
        switch route {
        case let .showDetail(parameters): // parameters
            let vm = MissionDetailViewModel(displayItem: parameters)
            return .push(vc: MissionDetailViewController(viewModel: vm))
        }
    }
}
