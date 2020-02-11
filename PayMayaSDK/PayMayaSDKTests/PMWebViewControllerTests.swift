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
import WebKit
@testable import PayMayaSDK

class PMWebViewControllerTests: XCTestCase {

    func test_init_setsTitle() {
        let title = "test"
        let sut = PMWebViewController(title: title)
        sut.title = title
    }
    
    func test_givenVC_whenViewLoads_setsNavigationDelegate() {
        let sut = PMWebViewController(title: "")
        let delegate: WKNavigationDelegate = sut
        
        sut.loadViewIfNeeded()
        XCTAssert((sut.view as? PMWebView)?.webView.navigationDelegate === delegate)
    }
    
    func test_givenVC_whenGetsIncorrectURL_callsOnError() {
        let sut = PMWebViewController(title: "")
        
        var capturedError: NetworkError?
        
        sut.onError = {
            capturedError = $0 as? NetworkError
        }
        
        let url = ""
        sut.loadURL(url)
        XCTAssertNotNil(capturedError)
        XCTAssertEqual(capturedError?.localizedDescription, NetworkError.invalidURL(url: url).localizedDescription)
    }
    
    func test_givenVC_whenGetsURL_loadsWebView() {
        let sut = PMWebViewController(title: "")
        
        var capturedError: Error?
        
        sut.onError = {
            capturedError = $0
        }
        
        let url = "www.test.com"
        sut.loadURL(url)
        let webView = (sut.view as? PMWebView)?.webView
        XCTAssertNil(capturedError)
        XCTAssertEqual(webView?.url?.absoluteString, url)
    }
    
    func test_givenVC_whenLoaded_viewIsPMWebView() {
        let sut = PMWebViewController(title: "")
        sut.loadViewIfNeeded()
        XCTAssert(sut.view is PMWebView)
    }
}
