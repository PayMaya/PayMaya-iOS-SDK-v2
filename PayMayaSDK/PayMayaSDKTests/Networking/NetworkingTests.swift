//
//  Copyright (c) 2020 PayMaya Philippines, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
//  NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest
@testable import PayMayaSDK

class NetworkingTests: XCTestCase {
    
    func test_givenCorrectRequest_whenSuccess_getsProperParsedObject() {
        let mockData = """
            { "name": "test" }
        """.data(using: .utf8)

        let network = MockFoundationNetworking(completion: (mockData, nil, nil))
        network.make(CorrectRequest()) { result in
            switch result {
            case .success(let object):
                XCTAssertEqual(object.name, "test")
            case .error, .failure:
                XCTFail("Shouldn't get any error")
            }
        }
    }
    
    func test_givenCorrectRequest_whenGets200Error_getsFailureWithErrorData() {
        struct MockError: Decodable {
            let error: String
        }
        
        let mockDataError = """
            { "error": "testError" }
        """.data(using: .utf8)

        let network = MockFoundationNetworking(completion: (mockDataError, nil, nil))
        network.make(CorrectRequest()) { result in
            switch result {
            case .failure(let data):
                let object: MockError? = data.parseJSON()
                XCTAssertEqual(object?.error, "testError")
            case .success, .error:
                XCTFail("Shouldn't get success or standard error")
            }
        }
    }
    
    func test_givenCorrectRequest_whenGetsError_getProperErrorCase() {
        enum MockError: LocalizedError {
            case testError
            var errorDescription: String? { return "test" }
        }
        
        let network = MockFoundationNetworking(completion: (nil, nil, MockError.testError))
        network.make(CorrectRequest()) { result in
            switch result {
            case .error(let error):
                XCTAssertEqual(error.localizedDescription, MockError.testError.localizedDescription)
            default:
                XCTFail("Should get an error")
            }
        }
    }
    
    func test_givenCorrectRequest_whenGetsNoDataAndNoError_getsProperError() {
        let network = MockFoundationNetworking(completion: (nil, nil, nil))
        network.make(CorrectRequest()) { result in
            switch result {
            case .error(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.unknown.localizedDescription)
            case .success, .failure:
                XCTFail("Should get an unknown error")
            }
        }
    }
    
    func test_givenIncorrectRequest_whenGetsCallback_getsInvalidURLError() {
        let testError = NetworkError.invalidURL(url: "")
        let network = URLSession.shared
        network.make(IncorrectRequest()) { result in
            switch result {
            case .error(let error):
                let networkError = (error as? NetworkError)
                XCTAssertEqual(networkError?.localizedDescription, testError.localizedDescription)
            default:
                XCTFail("Should get an error")
            }
        }
    }

}
