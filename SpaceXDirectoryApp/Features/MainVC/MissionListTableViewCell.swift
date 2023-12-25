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
    
    // MARK: - Public functions
    func fill(missionModel: Mission) {
        img.load(url: missionModel.icon)
        lblName.text = missionModel.name
        lblFlights.text = "First stage reuses: \(String(missionModel.firstStageReuses))"
        lblStatus.text = "Status: \(missionModel.success)"
        lblDate.text = "Date: \(missionModel.dateString)"
    }
    
    // MARK: - Private functions
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
        let leftIndent: CGFloat = 12
        let topIndent: CGFloat = 8
        let imgWidth: CGFloat = 65
        let imgHeight: CGFloat = 65
        let lblWidth: CGFloat = 145
        let lblHeight: CGFloat = 25
        
        img.CenterY == contentView.CenterY
        img.Left == contentView.Left + leftIndent
        img.Width == imgWidth
        img.Height == imgHeight
        
        lblName.Top == contentView.Top + topIndent
        lblName.Left == img.Right + leftIndent
        lblName.Width == lblWidth
        lblName.Height == lblHeight * 1.5
        
        lblFlights.Top == lblName.Bottom + topIndent
        lblFlights.Left == img.Right + leftIndent
        lblFlights.Width == lblWidth
        lblFlights.Height == lblHeight
        
        lblStatus.Top == contentView.Top + topIndent
        lblStatus.Left == lblName.Right + leftIndent
        lblStatus.Width == lblWidth
        lblStatus.Height == lblHeight * 1.5
        
        lblDate.Top == lblName.Bottom + topIndent
        lblDate.Left == lblName.Right + leftIndent
        lblDate.Width == lblWidth
        lblDate.Height == lblHeight
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
