//
//  NewsManagerTests.swift
//  ApaNYTimesTests
//
//  Created by Apanasenko Mikhail on 17.10.2021.
//

import XCTest
@testable import ApaNYTimes

class NewsManagerDelegateMock: NewsManagerDelegate {
    var didUpdateDataCount: Int = 0
    var didFailWithErrorCount: Int = 0
    var didFailWithNotValidURLCount: Int = 0
    var didFailWithNotValidJSONCount: Int = 0
    var didFailWithNoInternetConnection: Int = 0
    var didFailWithBrokenFile: Int = 0
    
    func didFailWithError(error: Error) {
        switch error.localizedDescription {
        case "Not valid URL":
            didFailWithNotValidURLCount += 1
        case "Not valid JSON recieved":
            didFailWithNotValidJSONCount += 1
        case "The operation couldn’t be completed. (NSURLErrorDomain error -1005.)":
            didFailWithNoInternetConnection += 1
        case "Couldn't read file. Please update feed":
            didFailWithBrokenFile += 1
        default:
            didFailWithErrorCount += 1
        }
        
        
        URLProtocolMock.expectation?.fulfill()
    }
    
    func didUpdateData(model: NewsModel) {
        didUpdateDataCount += 1
        URLProtocolMock.expectation?.fulfill()
        
    }
    
    
}

// Mock-версия URLProtocol взята отсюда: https://www.udemy.com/course/unit-testing-ios-mobile-app/


class URLProtocolMock: URLProtocol {
    static var stubResponseData: Data?
    static var expectation: XCTestExpectation?
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = URLProtocolMock.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocol(self, didLoad: URLProtocolMock.stubResponseData ?? Data())
        }
        
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
    
}

class NewsManagerTests: XCTestCase {
    
    var sut: NewsManager!
    var delegate: NewsManagerDelegateMock!
    var session: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NewsManager()
        delegate = NewsManagerDelegateMock()
        sut.delegate = delegate
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: config)
    }

    override func tearDownWithError() throws {
        URLProtocolMock.expectation = nil
        URLProtocolMock.stubResponseData = nil
        URLProtocolMock.error = nil
        delegate = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testNewsManager_WhenValidURLRequestedAndRightJSONRecived_ShouldCallDelegateMethodDidUpdateData () {
      
        //Arrange
        let url = "https://example.com/"
        let exampleJson = try? JSONEncoder().encode(validJSONExample)
        URLProtocolMock.stubResponseData = exampleJson
        let expectation = self.expectation(description: "Delegate method should be called")
        URLProtocolMock.expectation = expectation
        
        //Act
        sut.updateData(url, session)
        //Assert
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(delegate.didUpdateDataCount, 1, "updateData() should call didUpdateData, but didn't")
    }
    
    func testNewsManager_WhenValidURLRequestedAndWrongJSONRecieved_ShouldReturnSpecificError () {
        //Arrange
        let url = "https://example.com/"
        let exampleJson = try? JSONEncoder().encode(notValidJSONExample)
        URLProtocolMock.stubResponseData = exampleJson
        let expectation = self.expectation(description: "Delegate method should be called")
        URLProtocolMock.expectation = expectation
        
        //Act
        sut.updateData(url, session)
        
        //Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(delegate.didFailWithNotValidJSONCount, 1, "updateData() should call didFailWithError with no valid JSON error, but didn't")

    }
    
    func testNewsManager_WhenNotValidURLRequested_ShouldReturnSpecificError () {
        //Arrange
        let url = ""
        let expectation = self.expectation(description: "Delegate method should be called")
        URLProtocolMock.expectation = expectation
        //Act
        sut.updateData(url, session)
        //Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(delegate.didFailWithNotValidURLCount, 1, "updateData() should call didFailWithError with no valid URL error, but didn't")
    }
    
    func testNewsManager_WhenInternetConnectionIsLost_ShouldReturnSpecificError () {
        //Arrange
        let url = "https://example.com/"
        let expectation = self.expectation(description: "Delegate method should be called")
        URLProtocolMock.expectation = expectation
        let error = URLError(URLError.Code.networkConnectionLost)
        URLProtocolMock.error = error
        //Act
        sut.updateData(url, session)
        //Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(delegate.didFailWithNoInternetConnection, 1, "updateData() should call didFailWithError with no internet connection error, but didn't")
    }
    
    func testNewsManager_WhenValidFileURLPassedWithValidFile_ShouldCallDelegateMethodDidUpdateData () {
        //Arrange
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("TestJson.bin")
        let exampleJson = try! JSONEncoder().encode(validJSONExample)
        try! exampleJson.write(to: url, options: [.completeFileProtection])
        URLProtocolMock.stubResponseData = exampleJson
        let expectation = self.expectation(description: "Delegate method should be called")
        URLProtocolMock.expectation = expectation
        //Act
        sut.readData(url)
        //Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(delegate.didUpdateDataCount, 1, "readData() should call didUpdateData, but didn't")
    }
    
    func testNewsManager_WhenValidFileURLPassedButNoReadableFileFound_ShouldCallDelegateMethodDidUpdateData () {
        //Arrange
        let url = FileManager.default.temporaryDirectory
        
        let expectation = self.expectation(description: "Delegate method should be called")
        URLProtocolMock.expectation = expectation
        //Act
        sut.readData(url)
        //Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(delegate.didFailWithBrokenFile, 1, "readData() should call didFailWithError with broken file error, but didn't")
    }
    
    func testNewsManager_WhenNotValidFileURLPassed_ShouldCallDelegateMethodDidUpdateData () {
        //Arrange
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("TestNoFile.bin")
        
        let expectation = self.expectation(description: "Delegate method should be called")
        URLProtocolMock.expectation = expectation
        //Act
        sut.readData(url)
        //Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(delegate.didUpdateDataCount, 1, "readData() should call didUpdateData, but didn't")
    }
    
    func testNewsManager_WhenValidURLRequestedToLoadPicture_ShouldRecieveResponse () {
        //Arrange
        let article = validJSONExample.results[0]!
        let format = "Standard Thumbnail"
        let expectation = self.expectation(description: "Delegate method should be called")
        URLProtocolMock.expectation = expectation
        //Act
        sut.loadPicture(for: article, format: format) { _, response, _ in
            //Assert
            
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    let notValidJSONExample = ["status": "fail"]
    
    let validJSONExample = NewsData(
        status: "OK",
        copyright: "Test_copyright",
        section: "Test_section",
        last_updated: "Test_last_updated",
        num_results: 1,
        results: [
            Article(
                section: "Test_section",
                title: "Test_title",
                abstract: "Test_abstract",
                url: "https://example.com",
                byline: "Test_byline",
                published_date: "Test_published_date",
                multimedia: [
                    Multimedia(
                        url: "https://raw.githubusercontent.com/krasmikes/kek/master/partners_bd_528x364.png?token=AKNAZVGBF2KV3W7CGGIUJ5DBNVNQ2",
                        format: "superJumbo",
                        height: 0,
                        width: 0,
                        caption: "Test_caption",
                        copyright: "Test_copyright"),
                    Multimedia(
                        url: "https://raw.githubusercontent.com/krasmikes/kek/master/speech_bd_528x364.png?token=AKNAZVAB3DLT7FVK3ATGPYTBNVOWM",
                        format: "Standard Thumbnail",
                        height: 0,
                        width: 0,
                        caption: "Test_caption",
                        copyright: "Test_copyright")
                ],
                smallPicture: nil,
                bigPicture: nil)
        ])


//"""
//    {
//        "status": "OK",
//        "copyright": "Test-copyright",
//        "section": "Test-section",
//        "last_updated": "Test-last_updated",
//        "num_results": 1,
//        "results": [
//            {
//                "section": "Test-section",
//                "subsection": "Test-subsection",
//                "title": "Test-title",
//                "url": "https://example.com",
//                "uri": "Test-uri",
//                "byline": "Test-byline",
//                "item_type": "Test-item_type",
//                "updated_date": "Test-updated_date",
//                "created_date": "Test-created_date",
//                "published_date": "Test-published_date",
//                "material_type_facet": "Test-material_type_facet",
//                "kicker": "Test-material_type_facet",
//                "des_facet": [
//                    "Test-des_facet"
//                ],
//                "org_facet": [
//                    "Test-org_facet"
//                ],
//                "per_facet": [
//                    "Test-per_facet"
//                ],
//                "geo_facet": [
//                    "Test-geo_facet"
//                ],
//                "multimedia": [
//                    {
//                        "url": "https://raw.githubusercontent.com/krasmikes/kek/master/partners_bd_528x364.png?token=AKNAZVGBF2KV3W7CGGIUJ5DBNVNQ2",
//                        "format": "superJumbo",
//                        "height": 0,
//                        "width": 0,
//                        "type": "Test-type",
//                        "subtype": "Test-subtype",
//                        "caption": "Test-caption",
//                        "copyright": "Test-copyright"
//                    },
//                    {
//                        "url": "https://raw.githubusercontent.com/krasmikes/kek/master/speech_bd_528x364.png?token=AKNAZVAB3DLT7FVK3ATGPYTBNVOWM",
//                        "format": "Standard Thumbnail",
//                        "height": 0,
//                        "width": 0,
//                        "type": "Test-type",
//                        "subtype": "Test-subtype",
//                        "caption": "Test-caption",
//                        "copyright": "Test-copyright"
//                    }
//                ],
//                "short_url": "https://example.com"
//            }
//        ]
//    }
//"""

}
