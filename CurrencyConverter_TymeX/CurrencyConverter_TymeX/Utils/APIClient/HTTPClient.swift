//
//  HTTPClient.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Foundation

import Foundation

enum NetworkError: Error, Identifiable {
    case badRequest
    case decodingError(Error)
    case invalidResponse
    case errorResponse(ErrorResponse)

    var id: String {
        self.localizedDescription
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad Request (400): Unable to perform the request.", comment: "badRequestError")
        case .decodingError:
            return NSLocalizedString("Unable to decode successfully.", comment: "decodingError")
        case .invalidResponse:
            return NSLocalizedString("Invalid response.", comment: "invalidResponse")
        case .errorResponse(let errorResponse):
            return NSLocalizedString("Error \(errorResponse.errorType ?? "") check error description in HTTPClient", comment: "Error Response")
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badRequest, .badRequest):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.errorResponse(let lhsError), .errorResponse(let rhsError)):
            return lhsError.errorType == rhsError.errorType
        case (.decodingError, .decodingError):
            return false
        default:
            return false
        }
    }
}
enum HTTPMethod {
    case get
    case post(Data?)
    case delete
    case put(Data?)
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}
struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get
    var headers: [String: String]? = nil
    var modelType: T.Type
}
struct HTTPClient {
    private let session: URLSession
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }
        func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        print("DEBUG: The request url: \(resource.url.absoluteString)")
        print("DEBUG: Resource info: \(resource)")
        var request = URLRequest(url: resource.url)
        switch resource.method {
        case .get:
            request.httpMethod = resource.method.name
        case .post(let data), .put(let data):
            if let data{
              request.httpBody = data
            }
            request.httpMethod = resource.method.name
        case .delete:
            request.httpMethod = resource.method.name
        }
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        if let headers = resource.headers {
                  for (key, value) in headers {
                      request.setValue(value, forHTTPHeaderField: key)
                  }
              }
              
              let (data, response) = try await session.data(for: request)
            print("request being sent: \(request)")
        print("DEBUG: Received data: \(data)")
        if let jsonString = String(data: data, encoding: .utf8) {
            print("DEBUG: Received JSON: \(jsonString)")
        } else {
            print("DEBUG: Unable to convert data to string")
        }
        
        print("DEBUG: Type of 'data': \(type(of: data))")
              guard let httpResponse = response as? HTTPURLResponse else {
                  throw NetworkError.invalidResponse
              }
              
              switch httpResponse.statusCode {
                  case 200...299:
                      break // Success
                  default:
                      let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                      throw NetworkError.errorResponse(errorResponse)
              }
              
              do {
                  let result = try JSONDecoder().decode(resource.modelType, from: data)
                  return result
              } catch {
                  print("DECODING ERROR: \(error)")
                  throw NetworkError.decodingError(error)
              }
    }
}

//MARK: -ERROR DOCUMENTATION OF ExchangeRate-API
///Where "error-type" can be any of the following:
//"unsupported-code" if we don't support the supplied currency code (see supported currencies...).
//"malformed-request" when some part of your request doesn't follow the structure shown above.
//"invalid-key" when your API key is not valid.
//"inactive-account" if your email address wasn't confirmed.
//"quota-reached" when your account has reached the the number of requests allowed by your plan.

struct ErrorResponse: Codable {
    let result: String?
    let errorType: String?
    //CodingKeys is for conforming to Codable and mapping JSON keys
    private enum CodingKeys: String, CodingKey {
        case result
        case errorType = "error-type"
    }
}


