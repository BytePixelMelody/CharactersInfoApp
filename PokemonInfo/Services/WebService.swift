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

    enum WebServiceError: LocalizedError {
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
            throw WebServiceError.invalidUrlString(url)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WebServiceError.invalidServerResponse(response.description)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

}
