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
    
    // MARK: - Public method
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
        let cTopIndent: CGFloat = 8
        let cLeftIndent: CGFloat = 15
        let cLblWidth: CGFloat = 80
        let cLblHeight: CGFloat = 50
        
        lblCrewmateName.Top == contentView.Top + cTopIndent
        lblCrewmateName.Left == contentView.Left
        lblCrewmateName.Width == cLblWidth * 2
        lblCrewmateName.Height == cLblHeight
        
        lblAgency.Top == contentView.Top + cTopIndent
        lblAgency.Left == lblCrewmateName.Right + cLeftIndent
        lblAgency.Width == cLblWidth
        lblAgency.Height == cLblHeight
        
        lblStatus.Top == contentView.Top + cTopIndent
        lblStatus.Left == lblAgency.Right + cLeftIndent
        lblStatus.Width == cLblWidth
        lblStatus.Height == cLblHeight
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
