//
//  NewsManagerTests.swift
//  ApaNYTimesTests
//
//  Created by Apanasenko Mikhail on 17.10.2021.
//

import XCTest
@testable import ApaNYTimes

class NewsManagerDelegateMock: NewsManagerDelegate {
    var didFailWithErrorCount: Int = 0
    var didUpdateDataCount: Int = 0
    
    func didFailWithError(error: Error) {
        didFailWithErrorCount += 1
    }
    
    func didUpdateData(model: NewsModel) {
        didUpdateDataCount += 1
    }
    
    
}

// Mock-версия URLSession взята отсюда: https://www.swiftbysundell.com/articles/mocking-in-swift/

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {

    var data: Data?
    var error: Error?

    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error

        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}

class NewsManagerTests: XCTestCase {
    
    var sut: NewsManager!
    var delegate: NewsManagerDelegateMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NewsManager()
        delegate = NewsManagerDelegateMock()
        sut.delegate = delegate
    }

    override func tearDownWithError() throws {
        delegate = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testNewsManager_WhenRightURLRequestedAndRightJSONRecived_ShouldReturnOK () {
//        func updateData (_ url: String = Urls.automobiles, _ session: URLSession = URLSession(configuration: .default)) {
//            if let url = URL(string: url) {
//                request(for: url, session: session) { data, _, error in
//                    if let error = error {
//                        self.delegate?.didFailWithError(error: error)
//                        return
//                    }
//                    if let safeData = data {
//                        if let model = self.parseJSON(safeData) {
//                            saveData(for: model)
//                            delegate?.didUpdateData(model: model)
//                        }
//                    }
//                }
//            }
//        }
        
        //Arrange
        let session = URLSessionMock()
        let url = "https://example.com/"
        
        //Act
        sut.updateData(url, session)
        //Assert
        XCTAssertEqual(delegate.didUpdateDataCount, 1, "updateData() should call didUpdateData, but didn't")
    }

    

}
