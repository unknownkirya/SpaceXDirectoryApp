//
//  CrewTableViewCell.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 20.12.2023.
//

import UIKit
import Stevia

//MARK: - CrewTableViewCell
final class CrewTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    private lazy var lblCrewmateName: UILabel = createLbl()
    private lazy var lblAgency: UILabel = createLbl()
    private lazy var lblStatus: UILabel = createLbl()
    
    // MARK: = Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func fill(crewmateExample: Crewmate) {
        lblCrewmateName.text = crewmateExample.name
        lblAgency.text = crewmateExample.agency
        lblStatus.text = crewmateExample.status
    }
    
    // MARK: Private methods
    private func setupUI() {
        backgroundColor = .blackBG
        selectionStyle = .none
        
        subviews(
            lblCrewmateName,
            lblAgency,
            lblStatus
        )
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let topIndent: CGFloat = 8
        let leftIndent: CGFloat = 15
        let lblWidth: CGFloat = 80
        let lblHeight: CGFloat = 50
        
        lblCrewmateName.Top == contentView.Top + topIndent
        lblCrewmateName.Left == contentView.Left
        lblCrewmateName.Width == lblWidth * 2
        lblCrewmateName.Height == lblHeight
        
        lblAgency.Top == contentView.Top + topIndent
        lblAgency.Left == lblCrewmateName.Right + leftIndent
        lblAgency.Width == lblWidth
        lblAgency.Height == lblHeight
        
        lblStatus.Top == contentView.Top + topIndent
        lblStatus.Left == lblAgency.Right + leftIndent
        lblStatus.Width == lblWidth
        lblStatus.Height == lblHeight
    }
    
    private func createLbl() -> UILabel {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = .white
        lbl.backgroundColor = .blackBG
        lbl.numberOfLines = 2
        
        return lbl
    }
}
