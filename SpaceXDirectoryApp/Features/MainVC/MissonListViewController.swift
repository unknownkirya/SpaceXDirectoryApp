//
//  ViewController.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 08.12.2023.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

// MARK: - MissonListViewController
final class MissonListViewController: UIViewController {
    
    // MARK: - Private methods
    private let viewModel: MissonListViewModelProtocol
    private let bag = DisposeBag()
    
    private var currentPage = 1
    private lazy var router = MissionListRouter(navigationController: navigationController)
    
    private lazy var tbl: UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = .blackBG
        tbl.dataSource = self
        tbl.delegate = self
        tbl.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tbl
    }()

    // MARK: - Life cycle
    init(repository: MissionListRepository) {
        self.viewModel = MissionListViewModel(repository: repository)
        
        super.init(nibName: nil, bundle: nil)
        
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupBindings() {
        viewModel.reloadTable
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in
                self?.tbl.reloadData()
            })
            .disposed(by: bag)
    }
    
    private func setupUI() {
        view.backgroundColor = .blackBG
        view.subviews (
            tbl
        )
        
        tbl.fillContainer()
        
        setupNavigationTitle()
    }
    
    private func setupNavigationTitle() {
        guard let navigationController else { return }
        
        navigationItem.title = "SpaceX missions"
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if #available(iOS 13.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}


// MARK: - UITableViewDataSource
extension MissonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier) as? MainTableViewCell
        guard let tblCell = cell else { return UITableViewCell() }
        let cellMission = viewModel.recieveMission(indexPath: indexPath)
        tblCell.fill(missionModel: cellMission)
        return tblCell
    }
}

// MARK: - UITableViewDelegate
extension MissonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.kCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let missionCacheElement = viewModel.repository.missionCache[indexPath.row]
        router.run(route: .showDetail(parameters: missionCacheElement))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if viewModel.numberOfRows() >= currentPage * 10, offsetY > contentHeight - height {
            currentPage += 1
            viewModel.fetchData(page: currentPage)
        }
    }
}
