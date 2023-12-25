//
//  MissionListUseCase.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 18.12.2023.
//

import Foundation

// MARK: - MissionListUseCase
final class MissionListUseCase {
    
    
    // MARK: - Public function
    func prepareItems(exampleModel: MissionModels) -> [Mission] {
        var displayItems: [Mission] = []
        
        exampleModel.forEach { element in
            let res = prepareItem(parameters: element)
            displayItems.append(res)
        }
        return displayItems
    }
    
    // MARK: - Private function
    private func prepareItem(parameters: MissionElement) -> Mission {
        Constants.formatter.dateFormat = "dd-MM-YY"
        
        let name = parameters.name
        let firstStageReuses = parameters.cores.reduce(0) { result, core in
            result + (core.flight ?? 0)
        }
        let date = Constants.formatter.string(from: parameters.dateLocal)
        let success = parameters.success ?? false
        let successString = success ? "Success" : "Not success"
        
        guard let icon = parameters.links.patch.small else {
            return Mission(icon: nil, name: name, firstStageReuses: firstStageReuses, success: successString, dateString: date, date: parameters.dateLocal)
        }
              
        return Mission(icon: icon, name: name, firstStageReuses: firstStageReuses, success: successString, dateString: date, date: parameters.dateLocal)
    }
}
