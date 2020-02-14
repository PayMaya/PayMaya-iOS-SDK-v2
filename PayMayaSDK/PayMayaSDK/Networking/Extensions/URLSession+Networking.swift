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

extension URLSession: Networking, FoundationNetworking { }

extension Networking where Self: FoundationNetworking {
    func make<NetworkRequest: Request>(_ request: NetworkRequest, callback: @escaping (NetworkResult<NetworkRequest.Response>) -> Void) {
        guard let urlRequest = URLRequest(request: request) else {
            callback(.error(NetworkError.invalidURL(url: request.url)))
            return
        }
        Log.info("Networking: creating dataTask for API request: \(urlRequest.url?.absoluteString ?? "empty")")
        dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                callback(.error(error))
                Log.error("Networking: error calling API request: \(response?.url?.absoluteString ?? "empty")")
                return
            }
            
            if let data = data {
                if let responseObject = request.json(from: data) {
                    Log.info("Networking: parsed response for API request: \(response?.url?.absoluteString ?? "empty")")
                    callback(.success(responseObject))
                } else {
                    Log.error("Networking: failed parsing response for API request: \(response?.url?.absoluteString ?? "empty")")
                    callback(.failure(data))
                }
                return
            }
            
            callback(.error(NetworkError.unknown))

        }.resume()
    }
}
