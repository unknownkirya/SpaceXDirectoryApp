//
//  MissionDetailUseCase.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 19.12.2023.
//

import Foundation

// MARK: - MissionDetailUseCase
final class MissionDetailUseCase {
    
    // MARK: - Public functions
    
    func prepareSortedItems(parametrs: MissionModels) -> MissionModels {
        let dateToCheck = Constants.formatter.date(from: "01-01-2021") ?? Date()
        var sortedMissionModels: MissionModels = []
        
        parametrs.forEach { element in
            let date = element.dateLocal
            if date > dateToCheck {
                sortedMissionModels.append(element)
            }
        }
        return sortedMissionModels.sorted(by: { $0.dateLocal > $1.dateLocal })
    }
    
    func prepareMissionItem(parameters: MissionElement) -> MissionDetail {
        Constants.formatter.dateFormat = "dd-MM-yy"
        let name = parameters.name
        let details = parameters.details ?? "No details"
        let crew = parameters.crew
        let firstStageReuses = parameters.cores.reduce(0) { result, core in
            result + (core.flight ?? 0)
        }
        let date = Constants.formatter.string(from: parameters.dateLocal)
        let success = parameters.success ?? false
        let successString = success ? "Success" : "Not success"
        
        guard let icon = parameters.links.patch.small else {
            return MissionDetail(icon: nil, name: name, firstStageReuses: firstStageReuses, status: successString, dateString: date, details: details, crew: crew)
        }
              
        return MissionDetail(icon: icon, name: name, firstStageReuses: firstStageReuses, status: successString, dateString: date, details: details, crew: crew)
    }
    
    func prepareCrewmateItem(parameters: CrewmateModels) -> [String: Crewmate] {
        var displayElements: [String: Crewmate] = [:]
        
        parameters.forEach { element in
            let crewmate = Crewmate(name: element.name, agency: element.agency, status: element.status)
            displayElements[element.id] = crewmate
        }
        return displayElements
    }
}
