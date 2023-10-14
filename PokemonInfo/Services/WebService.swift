//
//  WebService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 12.10.2023.
//

import Foundation

protocol WebServiceProtocol {
    func getApiValue<T: Codable>(from url: String) async throws -> T
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

    // MARK: Public Methods

    func getApiValue<T: Codable>(from url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw Errors.invalidUrlString(url)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Errors.invalidServerResponse(response.description)
        }
        
        // raw data check
        // if let string = String(data: data, encoding: .utf8) { print(string) }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(T.self, from: data)
    }

}
