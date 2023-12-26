//
//  MissionDetailUseCaseTest.swift
//  Functional tests
//
//  Created by Kirill Berezhnoy on 26.12.2023.
//

import XCTest
@testable import SpaceXDirectoryApp

final class MissionDetailUseCaseTest: XCTestCase {
    
    // MARK: - Input
    private var sut: MissionDetailUseCase!
    
    // MARK: - Overrided methods
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = MissionDetailUseCase()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    func testUseCase_putCorrectMissionDetail_returnsCorrectDisplayData() throws {
        // given
        let links = Links(patch:Patch(small: "small", large: "large"))
        let firstCores = [Core(core: "someIdentifier", flight: nil)]
        let secondCores = [Core(core: "someIdentifier", flight: 5)]
        let firstMissionElement = MissionElement(links: links,
                                            success: true,
                                            details: nil,
                                            crew: ["Crewmate1", "Crewmate2"],
                                            name: "First Mission",
                                            dateUtc: "2006-03-17T00:00:00.000Z",
                                            dateLocal: Date(timeIntervalSince1970: 50000),
                                            cores: firstCores)
        
        let secondMissionElement = MissionElement(links: links,
                                            success: true,
                                            details: "Some details",
                                            crew: ["Crewmate1", "Crewmate2"],
                                            name: "First Mission",
                                            dateUtc: "2006-03-17T00:00:00.000Z",
                                            dateLocal: Date(timeIntervalSince1970: 50000),
                                            cores: secondCores)
        let missionElements: MissionModels = [firstMissionElement]
        
        // when
        var displayItem = sut.prepareMissionItem(parameters: firstMissionElement)
        
        // then
        XCTAssertEqual(displayItem.icon, "small")
        XCTAssertEqual(displayItem.name, "First Mission")
        XCTAssertEqual(displayItem.firstStageReuses, 0)
        XCTAssertEqual(displayItem.status, "Success")
        XCTAssertEqual(displayItem.dateString, Constants.formatter.string(from: Date(timeIntervalSince1970: 50000)))
        XCTAssertEqual(displayItem.details, "No details")
        
        displayItem = sut.prepareMissionItem(parameters: secondMissionElement)
        
        XCTAssertEqual(displayItem.details, "Some details")
        XCTAssertEqual(displayItem.firstStageReuses, 5)
    }
    
    func testUseCase_putCorrectCrewmate_returnsCorrectDisplayData() throws {
        // given
        let crewmateModel = CrewmateModel(name: "Some name", agency: "Some agency", status: "Some status", id: "Some id")
        let crewmateModels: CrewmateModels = [crewmateModel]
        
        // when
        let displayItem = sut.prepareCrewmateItem(parameters: crewmateModels)
        
        // then
        XCTAssertEqual(displayItem[0].name, "Some name")
        XCTAssertEqual(displayItem[0].agency, "Some agency")
        XCTAssertEqual(displayItem[0].status, "Some status")
    }
}
