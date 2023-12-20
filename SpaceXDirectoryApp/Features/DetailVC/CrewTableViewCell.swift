//
//  CrewTableViewCell.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 20.12.2023.
//

import UIKit
import Stevia

//MARK: - CrewTableViewCell
class CrewTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    private lazy var lblCrewmateName: UILabel = createLbl()
    private lazy var lblAgency: UILabel = createLbl()
    private lazy var lblStatus: UILabel = createLbl()
    
    // MARK: - Public methods
    func fill(crewmateExample: Crewmate) {
        lblCrewmateName.text = crewmateExample.name
        lblAgency.text = crewmateExample.agency
        lblStatus.text = crewmateExample.status
        
        setupUI()
    }
    
    // MARK: Private methods
    private func setupUI() {
        backgroundColor = .blackBG
        
        subviews(
            lblCrewmateName,
            lblAgency,
            lblStatus
        )
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let topIndent: CGFloat = 15
        let leftIndent: CGFloat = 15
        let lblWidth: CGFloat = 85
        let lblHeight: CGFloat = 30
        
        lblCrewmateName.Top == self.Top + topIndent
        lblCrewmateName.Left == self.Left + leftIndent
        lblCrewmateName.Width == lblWidth
        lblCrewmateName.Height == lblHeight
        
        lblAgency.Top == self.Top + topIndent
        lblAgency.Left == lblCrewmateName.Right + leftIndent
        lblAgency.Width == lblWidth
        lblAgency.Height == lblHeight
        
        lblStatus.Top == self.Top + topIndent
        lblStatus.Left == lblAgency.Right + leftIndent
        lblStatus.Width == lblWidth
        lblStatus.Height == lblHeight
    }
    
    private func createLbl() -> UILabel {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = .white
        lbl.backgroundColor = .white
        
        return lbl
    }
}
