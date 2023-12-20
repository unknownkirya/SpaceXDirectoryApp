//
//  BaseUseCase.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 20.12.2023.
//

import Foundation

// MARK: - BaseUseCase
final class BaseUseCase {
    
    // MARK: - Public propeties
    func filterModel(exampleModel: MissionModels) -> MissionModels {
        Constants.formatter.dateFormat = "dd-MM-yy"
        let dateToCheck = Constants.formatter.date(from: "01-01-2021") ?? Date()
        var displayItems: MissionModels = []
        
        exampleModel.forEach { element in
            if element.dateLocal > dateToCheck {
                displayItems.append(element)
            }
        }
        return displayItems.sorted(by: { $0.dateLocal > $1.dateLocal })
    }
}
