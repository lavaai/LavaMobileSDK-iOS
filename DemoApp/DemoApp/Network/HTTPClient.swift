//
//  HTTPClient.swift
//  DemoApp
//

import Foundation

typealias APIOnSuccess<T: Codable> = (T) -> Void
typealias APIOnError = (Error) -> Void
typealias Headers = [String: String]

enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class HTTPClient {

    var baseURL: String
    var configuration: URLSessionConfiguration!
    var session: URLSession!

    init(
        baseURL: String
    ) {
        self.baseURL = baseURL

        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }

    /**
     Post JSON
     */
    func postJSON<T: Codable, U: Codable>(
            endpoint: String,
            headers: Headers?,
            data: U,
            onSuccess: @escaping (T) -> Void,
            onError: @escaping (Error) -> Void
    ) {
        guard let url: URL = URL(string: "\(baseURL)\(endpoint)") else {
            onError(APIError.invalidURL)
            assertionFailure("Invalid URL")
            return
        }
        
        let requestHeaders = buildHeaders(headers: headers)

        let request = buildRequest(
                url: url,
                method: .post,
                headers: requestHeaders
        )

        let successHandler = { (result: T) in
            print("\(url): \(result)")
            onSuccess(result)
        }

        let errorHandler = { (error: Error) in
            print("Error \(url): \(error)")
            onError(error)
        }


        let completionHandler = buildCompletionHandler(
                onSuccess: successHandler,
                onError: errorHandler
        )

        guard let requestBody = try? JSONEncoder().encode(data) else {
            onError(APIError.requestConversionError)
            return
        }

        let task = session.uploadTask(
                with: request,
                from: requestBody,
                completionHandler: completionHandler
        )

        task.resume()
    }

    func getJSON<T: Codable>(
            endpoint: String,
            headers: Headers?,
            onSuccess: @escaping (T) -> Void,
            onError: @escaping (Error) -> Void
    ) {
        guard let url: URL = URL(string: "\(baseURL)\(endpoint)") else {
            onError(APIError.invalidURL)
            assertionFailure("Invalid URL")
            return
        }

        
        let requestHeaders = buildHeaders(headers: headers)

        let request = buildRequest(
                url: url,
                method: .get,
                headers: requestHeaders
        )


        let successHandler = { (result: T) in
            print("\(endpoint): \(result)")
            onSuccess(result)
        }

        let errorHandler = { (error: Error) in
            print("Error \(endpoint): \(error)")
            onError(error)
        }

        let completionHandler = buildCompletionHandler(
                onSuccess: successHandler,
                onError: errorHandler
        )

        let task = session.dataTask(
                with: request,
                completionHandler: completionHandler
        )

        task.resume()
    }

    /**
     Build headers
     */
    func buildHeaders(
        headers: Headers?
    ) -> Headers {
        var ret = [
            "Content-Type": "application/json"
        ]
        
        guard let headers = headers else { return ret }
        
        for (key, value) in headers {
            ret[key] = value
        }

        return ret
    }

    /**
     Build base request
     */
    func buildRequest(
            url: URL,
            method: APIMethod,
            headers: [String: String]?
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }

    /**
     Build completion handler for different request types
     */
    func buildCompletionHandler<T: Codable>(
            onSuccess: @escaping APIOnSuccess<T>,
            onError: @escaping APIOnError
    ) -> (Data?, URLResponse?, Error?) -> Void {
            return { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
                
                guard let strongSelf = self else {
                    return
                }

                if error != nil {
                    strongSelf.handleError(
                            APIError.networkError(error: error!),
                            handler: onError
                    )
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    strongSelf.handleError(
                            APIError.unknownServerError,
                            handler: onError
                    )
                    return
                }
                
                do {
                    // Check response status
                    try strongSelf.checkStatus(httpResponse)
                    
                    // Perform decoding response
                    let result: T = try strongSelf.decodeResponse(data, httpResponse) as T
                    strongSelf.handleSuccess(
                            result,
                            handler: onSuccess
                    )
                } catch {
                    strongSelf.handleError(
                            error,
                            handler: onError
                    )
                }
        }
    }
    
    func checkStatus(_ httpResponse: HTTPURLResponse) throws {
        switch httpResponse.statusCode {
        case 100...399:
            break
        case 400:
            throw APIError.invalidInput
        case 401...403:
            throw APIError.unauthenticated
        case 500...599:
            throw APIError.serverError(code: httpResponse.statusCode)
        default:
            throw APIError.unknownServerError
        }
    }
    
    func decodeResponse<T: Codable>(_ data: Data?, _ httpResponse: HTTPURLResponse) throws -> T {
        guard let data = data else {
            throw APIError.emptyData
        }
        
        guard let mime = httpResponse.mimeType else {
            throw APIError.contentTypeError
        }

        // Handle application/json
        // TODO: Below code is ugly, needs refactor
        if T.self != String.self && mime == "application/json" {
            do {
                let decoder = JSONDecoder.custom
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Error converting from JSON response: \(error)")
                throw APIError.responseConversionError
            }
        } else if T.self == String.self && (mime == "text/plain" || mime == "text/html") {
            if let result = String(data: data, encoding: .utf8) {
                return result as! T
            } else {
                throw APIError.responseConversionError
            }
        }
        
        throw APIError.contentTypeError
    }

    func handleError(
            _ error: Error,
            handler: APIOnError? = nil
    ) {
        DispatchQueue.main.async {
            handler?(error)
        }
    }

    func handleSuccess<T: Codable>(
            _ value: T,
            handler: APIOnSuccess<T>? = nil
    ) {
        DispatchQueue.main.async {
            handler?(value)
        }
    }
}
