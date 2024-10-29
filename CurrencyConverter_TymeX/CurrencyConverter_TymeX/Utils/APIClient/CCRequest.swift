//
//  CCRequest.swift
//  CurrencyConverter_TymeX
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Foundation

final class CCRequest {
    ///API constant
    private struct Constants{
        static let baseUrl = "https://v6.exchangerate-api.com/v6/63fba12836a47603523b5bea"
    }
    ///endpoint
    let endpoint: CCEndpoint
    
    /// extra path component after the endpoint, if any
    private let pathComponents : [String]
    
    /// query parameters, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    // MARK: - Public
    ///  Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: additional compenent after endpoint
    ///   - queryParameters:   query options, if any
    public init(
        endpoint: CCEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ){
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    /// Create request from url given
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let CCEndpoint = CCEndpoint(
                    rawValue: endpointString
                ) {
                    self.init(endpoint: CCEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")

                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })

                if let CCEndpoint = CCEndpoint(rawValue: endpointString) {
                    self.init(endpoint: CCEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }

        return nil
    }
}
