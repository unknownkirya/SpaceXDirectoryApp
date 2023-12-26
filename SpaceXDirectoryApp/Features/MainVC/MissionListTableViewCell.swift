//
//  MainTableViewCell.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 08.12.2023.
//

import UIKit
import Stevia

// MARK: - MainTableViewCell
final class MainTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    private var img: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = Constants.kCornerRadius
        img.backgroundColor = .clear
        return img
    }()
    
    private lazy var lblName: UILabel = createLbl(text: "")
    private lazy var lblFlights: UILabel = createLbl(text: "")
    private lazy var lblStatus: UILabel = createLbl(text: "")
    private lazy var lblDate: UILabel = createLbl(text: "")
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func fill(missionModel: Mission) {
        img.load(url: missionModel.icon)
        lblName.text = missionModel.name
        lblFlights.text = "First stage reuses: \(String(missionModel.firstStageReuses))"
        lblStatus.text = "Status: \(missionModel.status)"
        lblDate.text = "Date: \(missionModel.dateString)"
    }
    
    // MARK: - Private methods
    private func setupUI() {
        backgroundColor = .blackBG
        selectionStyle = .none
        subviews (
            img,
            lblName,
            lblFlights,
            lblStatus,
            lblDate
        )
        
        createConstraints()
    }
    
    private func createConstraints() {
        let cLeftIndent: CGFloat = 12
        let cTopIndent: CGFloat = 8
        let cImgWidth: CGFloat = 65
        let cImgHeight: CGFloat = 65
        let cLblWidth: CGFloat = 145
        let cLblHeight: CGFloat = 25
        
        img.CenterY == contentView.CenterY
        img.Left == contentView.Left + cLeftIndent
        img.Width == cImgWidth
        img.Height == cImgHeight
        
        lblName.Top == contentView.Top + cTopIndent
        lblName.Left == img.Right + cLeftIndent
        lblName.Width == cLblWidth
        lblName.Height == cLblHeight * 1.5
        
        lblFlights.Top == lblName.Bottom + cTopIndent
        lblFlights.Left == img.Right + cLeftIndent
        lblFlights.Width == cLblWidth
        lblFlights.Height == cLblHeight
        
        lblStatus.Top == contentView.Top + cTopIndent
        lblStatus.Left == lblName.Right + cLeftIndent
        lblStatus.Width == cLblWidth
        lblStatus.Height == cLblHeight * 1.5
        
        lblDate.Top == lblName.Bottom + cTopIndent
        lblDate.Left == lblName.Right + cLeftIndent
        lblDate.Width == cLblWidth
        lblDate.Height == cLblHeight
    }
    
    private func createLbl(text: String, color: UIColor = .white) -> UILabel {
        let lbl = UILabel()
        lbl.textColor = color
        lbl.numberOfLines = 2
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = text
        lbl.backgroundColor = .blackBG
        return lbl
    }
}
