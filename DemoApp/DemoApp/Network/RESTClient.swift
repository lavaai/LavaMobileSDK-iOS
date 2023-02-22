//
//  APIClient.swift
//  DemoApp
//

import Foundation

struct LoginRequest: Codable {
    var email: String?
    var password: String?
}

struct RefreshTokenRequest: Codable {
    var email: String?
}

struct AuthResponse: Codable {
    var memberToken: String?
}

class RESTClient {
    
    public static var shared: RESTClient = RESTClient(baseURL: AppBackendBaseURL)

    private var httpClient: HTTPClient!
    
    
    private init(baseURL: String) {
        httpClient = HTTPClient(baseURL: baseURL)
    }
    
    func login(username: String,
               password: String,
               successCallback: @escaping APIOnSuccess<AuthResponse>,
               errorCallback: @escaping APIOnError
    ) {
        let loginRequest = LoginRequest(email: username, password: password)
        httpClient.postJSON(endpoint: "/login", headers: nil, data: loginRequest) { response in
            successCallback(response)
        } onError: { error in
            errorCallback(error)
        }
    }
    
    func refreshToken(username: String,
                      successCallback: @escaping APIOnSuccess<AuthResponse>,
                      errorCallback: @escaping APIOnError
    ) {
        let request = RefreshTokenRequest(email: username)

        httpClient.postJSON(endpoint: "/refresh_token", headers: nil, data: request) { response in
            successCallback(response)
        } onError: { error in
            errorCallback(error)
        }
    }
    
}
