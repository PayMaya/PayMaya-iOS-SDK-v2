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

/// List of redirect URLs depending on completion status. Required. Must be secure https url.
public struct RedirectURL: Encodable {
    
    /// Redirect URL when payment is successful.
    public let success: String
    
    /// Redirect URL when payment failes.
    public let failure: String
    
    /// Redirect URL when payment is cancelled.
    public let cancel: String
    
    /// List of redirect URLs depending on completion status. Required. Must be secure https url.
    /// - Parameters:
    ///   - success: Redirect URL when payment is successful.
    ///   - failure: Redirect URL when payment failes.
    ///   - cancel: Redirect URL when payment is cancelled.
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

/// Status of the process with the proper redirection url
public enum RedirectStatus {
    
    /// Successful status with success Redirect URL
    case success(String)
    
    /// Failure status with failure Redirect URL
    case failure(String)
    
    /// Cancelled status with cancel Redirect URL
    case cancel(String)
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
