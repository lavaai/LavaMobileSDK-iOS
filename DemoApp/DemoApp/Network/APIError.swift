//
//  APIError.swift
//  DemoApp
//
import Foundation

public enum APIError: Error {
    case unauthenticated
    case requireSecureMemberToken
    case tokenExpired
    case invalidInput
    case invalidURL
    case networkError(error: Error)
    case serverError(code: Int)
    case contentTypeError
    case emptyData
    case responseConversionError
    case requestConversionError
    case unknownServerError
    case unknownError
}

extension APIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unauthenticated:
            return "Unauthenticated. Please login again."
        case .requireSecureMemberToken:
            return "Secure member token is required."
        case .tokenExpired:
            return "Unauthenticated. Your token has already expired. "
        case .invalidInput:
            return "Invalid input."
        case .invalidURL:
            return "Invalid URL."
        case .networkError(let error):
            return "Network error: \(error)"
        case .serverError(let code):
            return "Server error: \(code)"
        case .emptyData:
            return "No data returned."
        case .contentTypeError:
            return "Content type error."
        case .responseConversionError:
            return "Response data conversion error."
        case .requestConversionError:
            return "Request data conversion error."
        case .unknownServerError:
            return "Unknown server error."
        default:
            return "Unknown error."
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        return description
    }
}
