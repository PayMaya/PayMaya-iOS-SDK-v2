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

import Foundation

public struct RedirectURL: Encodable {
    public let success: String
    public let failure: String
    public let cancel: String
    
    public init?(success: String, failure: String, cancel: String) {
        guard [success, failure, cancel].areSecureURLs else {
            Log.error("Unable to create redirectURL: URLs should start with https://")
            return nil
        }
        self.success = success
        self.failure = failure
        self.cancel = cancel
    }
}

public enum RedirectStatus {
    case success(String), failure(String), cancel(String)
}

extension RedirectURL {
    func status(for url: String) -> RedirectStatus? {
        switch url {
        case success:
            return .success(url)
        case failure:
            return .failure(url)
        case cancel:
            return .cancel(url)
        default:
            return nil
        }
    }
}

private extension Array where Element == String {
    var areSecureURLs: Bool {
        !map { $0.starts(with: "https://") }.contains(false)
    }
}
