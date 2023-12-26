//
//  MissionListUseCaseTest.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 26.12.2023.
//

import XCTest
@testable import SpaceXDirectoryApp

final class MissionListUseCaseTest: XCTestCase {
    
    // MARK: - Input
    private var sut: MissionListUseCase!

    // MARK: - Overrided methods
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = MissionListUseCase()
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Test
    func testUseCase_putCorrectMission_returnsCorrectDisplayData() throws {
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
                                            success: nil,
                                            details: nil,
                                            crew: ["Crewmate1", "Crewmate2"],
                                            name: "First Mission",
                                            dateUtc: "2006-03-17T00:00:00.000Z",
                                            dateLocal: Date(timeIntervalSince1970: 50000),
                                            cores: secondCores)
        let missionElements: MissionModels = [firstMissionElement]
        
        Constants.formatter.dateFormat = "dd-MM-YY"
        
        // when
        var displayItem = sut.prepareItems(exampleModel: missionElements)
        
        // then
        XCTAssertEqual(displayItem[0].icon, "small")
        XCTAssertEqual(displayItem[0].name, "First Mission")
        XCTAssertEqual(displayItem[0].firstStageReuses, 0)
        XCTAssertEqual(displayItem[0].status, "Success")
        XCTAssertEqual(displayItem[0].dateString, Constants.formatter.string(from: Date(timeIntervalSince1970: 50000)))
        
        displayItem = sut.prepareItems(exampleModel: [secondMissionElement])
        
        XCTAssertEqual(displayItem[0].firstStageReuses, 5)
        XCTAssertEqual(displayItem[0].status, "Not success")
        
    }
    
}
