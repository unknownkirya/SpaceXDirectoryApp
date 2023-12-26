//
//  MissionDetailViewController.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 11.12.2023.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

// MARK: - MissionDetailViewController
final class MissionDetailViewController: UIViewController {
    
    // MARK: - Public properties
    var viewModel: MissionDetailViewModelProtocol
    
    // MARK: Private properties
    private let displayItem: MissionDetail
    private let bag = DisposeBag()
    
    private var img: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = Constants.kCornerRadius
        img.backgroundColor = .blackBG
        
        return img
    }()
    
    private lazy var tbl: UITableView = { [weak self] in
        let tbl = UITableView()
        tbl.backgroundColor = .blackBG
        tbl.dataSource = self
        tbl.delegate = self
        tbl.register(CrewTableViewCell.self, forCellReuseIdentifier: CrewTableViewCell.identifier)
        
        return tbl
    }()
    
    private lazy var txtDetails: UITextView = {
        let txt = UITextView()
        txt.textContainer.maximumNumberOfLines = 0
        txt.isEditable = false
        txt.textColor = .white
        txt.backgroundColor = .blackBG
        txt.textAlignment = .left
        
        return txt
    }()
    
    private lazy var lblName: UILabel = createLbl(text: "", textAligment: .center, textSize: 23)
    private lazy var lblFlights: UILabel = createLbl(text: "")
    private lazy var lblStatus: UILabel = createLbl(text: "")
    private lazy var lblDate: UILabel = createLbl(text: "")
    private lazy var lblDetails: UILabel = createLbl(text: "Details:")
    private lazy var lblCrew: UILabel = createLbl(text: "Crew:")
    
    // MARK: Life cycle
    init(viewModel: MissionDetailViewModel) {
        self.viewModel = viewModel
        self.displayItem = viewModel.getDisplayItem()
        super.init(nibName: nil, bundle: nil)

        setupBindings()
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func fill() {
        img.load(url: displayItem.icon)
        lblName.text = displayItem.name
        lblFlights.text = "First stage reuses: \(displayItem.firstStageReuses)"
        lblStatus.text = "Status: \(displayItem.status)"
        lblDate.text = "Date: \(displayItem.dateString)"
        txtDetails.text = displayItem.details
        
        if displayItem.crew.count == 0 {
            lblCrew.text = ""
        }
    }
    
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
            img,
            lblName,
            lblFlights,
            lblStatus,
            lblDate,
            lblDetails,
            txtDetails,
            lblCrew,
            tbl
        )
        createConstraints()
    }
    
    private func createConstraints() {
        let leftIndent: CGFloat = 25
        let rightIndent: CGFloat = 25
        let topIndent: CGFloat = 10
        let topIndentFromNameLbl: CGFloat = 25
        let topIndentForImg: CGFloat = 125
        let imgWidth: CGFloat = 225
        let imgHeight: CGFloat = 225
        let lblWidth: CGFloat = 350
        let lblHeight: CGFloat = 30
        
        img.Top == view.Top + topIndentForImg
        img.CenterX == view.CenterX
        img.Width == imgWidth
        img.Height == imgHeight
        
        lblName.Top == img.Bottom + topIndent
        lblName.CenterX == view.CenterX
        lblName.Width == lblWidth
        lblName.Height == lblHeight * 2
        
        lblFlights.Top == lblName.Bottom + topIndentFromNameLbl
        lblFlights.Left == view.Left + leftIndent
        lblFlights.Width == lblWidth
        lblFlights.Height == lblHeight
        
        lblStatus.Top == lblFlights.Bottom + topIndent
        lblStatus.Left == view.Left + leftIndent
        lblStatus.Width == lblWidth
        lblStatus.Height == lblHeight
        
        lblDate.Top == lblStatus.Bottom + topIndent
        lblDate.Left == view.Left + leftIndent
        lblDate.Width == lblWidth
        lblDate.Height == lblHeight
        
        lblDetails.Top == lblDate.Bottom + topIndent
        lblDetails.Left == view.Left + leftIndent
        lblDetails.Width == lblWidth
        lblDetails.Height == lblHeight
        
        txtDetails.Top == lblDetails.Bottom + topIndent / 3
        txtDetails.Left == view.Left + leftIndent
        txtDetails.Width == lblWidth
        txtDetails.Height == lblHeight * 3
        
        lblCrew.Top == txtDetails.Bottom + topIndent
        lblCrew.Left == view.Left + leftIndent
        lblCrew.Width == lblWidth / 2
        lblCrew.Height == lblHeight
        
        tbl.Top == lblCrew.Bottom
        tbl.Left == view.Left + leftIndent
        tbl.Right == view.Right - rightIndent
        tbl.Bottom == view.Bottom
    }
    
    private func createLbl(text: String, textAligment: NSTextAlignment = .left, textSize: CGFloat = 17) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.numberOfLines = 0
        lbl.textAlignment = textAligment
        lbl.textColor = .white
        lbl.backgroundColor = .blackBG
        lbl.font = .systemFont(ofSize: textSize)
        
        return lbl
    }
}

// MARK: - UITableViewDataSource
extension MissionDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsOfCrew()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: CrewTableViewCell.identifier) as? CrewTableViewCell
        guard let tblCell = cell else { return UITableViewCell() }
        let crewmate = viewModel.crewmateForId(for: indexPath)
        tblCell.fill(crewmateExample: crewmate)
        
        return tblCell
    }
}

// MARK: - UITableViewDelegate
extension MissionDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.kCellHeight / 1.6
    }
}
