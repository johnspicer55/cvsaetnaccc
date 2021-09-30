//
//  CVSDemoAppTests.swift
//  CVSDemoAppTests
//
//  Created by John Spicer on 2021-09-29.
//

import XCTest
@testable import CVSDemoApp

class CVSDemoAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSONMapping() throws {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: "MockJson", withExtension: "json") else {
            XCTFail("Missing file: User.json")
            return
        }
        
        let json = try Data(contentsOf: url)
        let flkrData = try JSONDecoder().decode(Flkr.self, from: json)

        XCTAssertEqual(flkrData.items.count, 20)
        XCTAssertEqual(flkrData.title, "Recent Uploads tagged porcupine")
    }
}
