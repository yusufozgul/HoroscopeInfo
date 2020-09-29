//
//  APITest.swift
//  HoroscopeInfoTests
//
//  Created by Yusuf Özgül on 29.09.2020.
//

import XCTest
@testable import HoroscopeInfo

class APITest: XCTestCase {
    
    func test_ParseData_Success_shouldCheckResult() {
        guard let fileData = loadFile(fileName: "HoroscopeDetailData") else {
            XCTFail("File not load")
            return
        }
        let result = ParseFromData<HoroscopeDetailRequestResponse>.parse(data: fileData)
        XCTAssertNotNil(result)
        
        switch result {
        case .success(let data):
            XCTAssertEqual(data.ascendant, "Aquarius")
            XCTAssertEqual(data.charan, 3)
        case .failure(let error):
            XCTFail("This test is success test: \(error)")
        }
    }
    
    func test_ParseData_ErroredResponse_shouldCheckErrorResult() {
        guard let fileData = loadFile(fileName: "ErroredResponse") else {
            XCTFail("File not load")
            return
        }
        
        let result = ParseFromData<ApiResponseError>.parse(data: fileData)
        XCTAssertNotNil(result)

        switch result {
        case .success(let data):
            XCTFail("This test is error test: \(data)")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "API authentication failed!")

        }
    }
}

extension APITest {
    func loadFile(fileName: String) -> Data? {
        let bundle = Bundle(for: APITest.self)
        let url = bundle.url(forResource: fileName, withExtension: "json")
        guard let fileUrl = url else {
            return nil
        }
        return try? Data(contentsOf: fileUrl)
    }
}
