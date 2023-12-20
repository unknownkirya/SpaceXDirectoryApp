//
//  MainTableViewCell.swift
//  SpaceXDirectoryApp
//
//  Created by Кирилл Бережной on 08.12.2023.
//

import UIKit
import Stevia

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
//        if let icon = missionModel.icon {
//            img.load(url: icon)
//        } else {
//            img.image = UIImage(named: "notFoundImage")
//        }
        img.load(url: missionModel.icon)
        lblName.text = missionModel.name
        lblFlights.text = "First stage reuses: \(String(missionModel.firstStageReuses))"
        lblStatus.text = "Status: \(missionModel.success)"
        lblDate.text = "Date: \(missionModel.dateString)"
    }
    
    // MARK: - Private methods
    private func setupUI() {
        self.backgroundColor = .blackBG
        self.selectionStyle = .none
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
        let leftIndent: CGFloat = 15
        let topIndent: CGFloat = 10
        let imgWidth: CGFloat = 55
        let imgHeight: CGFloat = 55
        let lblWidth: CGFloat = 135
        let lblHeight: CGFloat = 20
        
        img.CenterY == self.CenterY
        img.Left == self.Left + leftIndent
        img.Width == imgWidth
        img.Height == imgHeight
        
        lblName.Top == self.Top + topIndent
        lblName.Left == img.Right + leftIndent
        lblName.Width == lblWidth
        lblName.Height == lblHeight
        
        lblFlights.Top == lblName.Bottom + topIndent
        lblFlights.Left == img.Right + leftIndent
        lblFlights.Width == lblWidth
        lblFlights.Height == lblHeight
        
        lblStatus.Top == self.Top + topIndent
        lblStatus.Left == lblName.Right + leftIndent
        lblStatus.Width == lblWidth
        lblStatus.Height == lblHeight
        
        lblDate.Top == lblStatus.Bottom + topIndent
        lblDate.Left == lblName.Right + leftIndent
        lblDate.Width == lblWidth
        lblDate.Height == lblHeight
    }
    
    private func createLbl(text: String, color: UIColor = .white) -> UILabel {
        let lbl = UILabel()
        lbl.textColor = color
        lbl.text = text
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = .blackBG
        return lbl
    }
}
