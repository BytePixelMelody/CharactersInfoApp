//
//  WebService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 12.10.2023.
//

import Foundation

protocol WebServiceProtocol {
    func getDecodedJSON<T: Codable>(by urlString: String) async throws -> T
    func getRawData(by urlString: String) async throws -> Data
}

final class WebService: WebServiceProtocol {

    // MARK: Types

    enum Errors: LocalizedError {
        case invalidServerResponse(String)
        case invalidUrlString(String)

        var errorDescription: String? {
            switch self {
            case .invalidServerResponse(let responseDescription):
                return "Invalid server response, description: \(responseDescription)"
            case .invalidUrlString(let urlString):
                return "Error while creating URL from string:\n\(urlString)"
            }
        }
    }
    
    // MARK: Constants
    
    private enum Constants {
        static let timeoutIntervalForRequest = 5.0
    }
    
    // MARK: Private Properties
    
    let urlSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constants.timeoutIntervalForRequest
        return URLSession(configuration: configuration)
    }()

    // MARK: Public Methods

    func getDecodedJSON<T: Codable>(by urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw Errors.invalidUrlString(urlString)
        }

        let (data, response) = try await urlSession.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Errors.invalidServerResponse(response.description)
        }
        
        // raw data check
        // if let string = String(data: data, encoding: .utf8) { print(string) }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(T.self, from: data)
    }
    
    func getRawData(by urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw Errors.invalidUrlString(urlString)
        }

        let (data, response) = try await urlSession.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Errors.invalidServerResponse(response.description)
        }

        return data
    }

}
