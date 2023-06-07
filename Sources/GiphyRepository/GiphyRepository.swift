//
//  GiphyRepository.swift
//  
//
//  Created by USER on 2023/06/06.
//

import Foundation
import GIFPediaService
import SHNetworkServiceInterface

public final class GiphyRepository: GIFRepository {
    private let networkService: SHNetworkServiceInterface
    private let apiKey: String
    private let limit: Int
    private var latestQuery: String = ""
    private var nextPage: Int = .zero

    public init(networkService: SHNetworkServiceInterface, apiKey: String, limit: Int = 100) {
        self.networkService = networkService
        self.apiKey = apiKey
        self.limit = limit
    }

    public func search(query: String) async -> [GIF] {
        do {
            let results = try await search(query: query, page: .zero)
            latestQuery = query
            nextPage = 1
            return results
        } catch {
            dump(error.localizedDescription)
            return []
        }
    }

    public func requestNext() async -> [GIF] {
        do {
            let results = try await search(query: latestQuery, page: nextPage)
            nextPage += 1
            return results
        } catch {
            dump(error.localizedDescription)
            return []
        }
    }

    private func search(query: String, page: Int) async throws -> [GIF] {
        let result: GiphySearchResultDTO = try await networkService.request(
            domain: "https://api.giphy.com/v1/gifs",
            path: "/search",
            method: .get,
            parameters: [
                "api_key": apiKey,
                "q": query,
                "limit": "\(limit)",
                "offset": "\(page)",
                "rating": "g",
                "lang": "en"
            ],
            headers: nil,
            body: nil
        )

        return result.data.compactMap { dto -> GIF? in
            guard let thumbnailUrl = dto.images.thumbnail,
                  let originalUrl = dto.images.original else { return nil }
            return GIF(
                id: "Giphy_\(dto.id)",
                title: dto.title,
                thumbnailUrl: thumbnailUrl,
                originalUrl: originalUrl
            )
        }
    }
}
