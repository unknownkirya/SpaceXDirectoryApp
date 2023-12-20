//
//  BaseRouter.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 11.12.2023.
//

import Foundation
import UIKit
import RxSwift

/// Описывает возможные типы переходов для `UINavigationController`
enum NavigationTransition {
    typealias CustomTransition = (UINavigationController?) -> Void
    
    case popTo(vc: UIViewController)
    case popToRoot
    
    case present(vc: UIViewController, completion: (() -> Void)? = nil)
    case push(vc: UIViewController)
    
    /// Сбрасывает стек контроллеров до первого и выполняет пуш
    case pushFromRoot(vc: UIViewController)
    
    /// Устанавливает новый стек контроллеров.
    case set(vcs: [UIViewController], animated: Bool)
    
    /// Заменяет текущий контроллер в стеке на переданный.
    case replace(vc: UIViewController)
    
    /// Выполнение кастомного перехода.
    case custom(transition: CustomTransition)
    
    /// Кейс выхода из логики перехода.
    case none
}

/// Базовый класс роутер.
/// - parameter RouteType: перечисление переходов для данного роутера.
class BaseRouter<RouteType> {
    
    private(set) weak var navigationController: UINavigationController?
    
    /// Utility `DisposeBag` used by the subclasses.
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("🚩 Router was deinitialized: \(self)")
    }
    
    /// Метод перехода на новую сцену с возвращением результата. Для выполнения перехода необходим `subscribe()`
    /// Вызывает `prepareTransition(for route: with result:)` перед переходом на следующий экран.
    /// - parameter route: выбранный переход.
    final func trigger(route: RouteType) -> Observable<Any?> {
        let resultObserver = PublishSubject<Any?>()
        let transition = prepareTransition(for: route, with: resultObserver)
        return resultObserver
            .do(onSubscribed: { [weak self] in
                self?.perform(transition: transition ?? .none)})
    }
    
    /// Метод перехода на новую сцену без возвращения результата.
    /// Вызывает `prepareTransition(for route: with result:)` без параметра `result` перед переходом на следующий экран.
    /// - parameter route: выбранный переход.
    final func run(route: RouteType) {
        let transition = prepareTransition(for: route, with: nil)
        perform(transition: transition ?? .none)
    }
    
    /// Создание `NavigationTransition` для перехода. Должен быть переопределен классами-наследниками.
    /// - parameter route: выбранный переход.
    /// - parameter result: объект, в который можно отправить результат, если вызов произошел из метода `trigger(route:)`
    /// - returns: возвращает вид `NavigationTransition` для перехода. В случае, если метод вернет `nil` - переход не будет осуществлен.
    func prepareTransition(for route: RouteType, with result: PublishSubject<Any?>?) -> NavigationTransition? {
        print("\(self): must implement \(#function)")
        return nil
    }
    
    /// Метод возврата на предыдущий экран.
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    /// Выполнение перехода. Описывает взаимодействие с `UINavigationController` для  всех типов `NavigationTransition`
    /// - parameter transition: текущий переход
    private func perform(transition: NavigationTransition) {
        switch transition {
        case .popTo(let vc):
            navigationController?.popToViewController(vc, animated: true)
        case .popToRoot:
            navigationController?.popToRootViewController(animated: true)
        case .present(let vc, let completion):
            navigationController?.present(vc, animated: true, completion: completion)
        case .push(let vc):
            navigationController?.pushViewController(vc, animated: true)
        case .pushFromRoot(let vc):
            let vcs = [navigationController?.viewControllers.first, vc].compactMap { $0 }
            navigationController?.setViewControllers(vcs, animated: true)
        case .set(let vcs, let animated):
            navigationController?.setViewControllers(vcs, animated: animated)
        case .replace(let vc):
            if let navigationController = navigationController {
                let vcs = Array(navigationController.viewControllers.dropLast() + [vc])
                navigationController.setViewControllers(vcs, animated: true)
            }
        case .custom(let customClousure):
            customClousure(navigationController)
        case .none:
            break
        }
    }
}
