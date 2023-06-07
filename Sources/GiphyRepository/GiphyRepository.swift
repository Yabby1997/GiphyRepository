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
    private var offset: Int = .zero

    public init(networkService: SHNetworkServiceInterface, apiKey: String, limit: Int = 100) {
        self.networkService = networkService
        self.apiKey = apiKey
        self.limit = limit
    }

    public func search(query: String) async -> [GIF] {
        do {
            let results = try await search(query: query, offset: .zero)
            latestQuery = query
            offset = results.count
            return results
        } catch {
            dump(error.localizedDescription)
            return []
        }
    }

    public func requestNext() async -> [GIF] {
        do {
            let results = try await search(query: latestQuery, offset: offset)
            offset += results.count
            return results
        } catch {
            dump(error.localizedDescription)
            return []
        }
    }

    private func search(query: String, offset: Int) async throws -> [GIF] {
        let result: GiphySearchResultDTO = try await networkService.request(
            domain: "https://api.giphy.com/v1/gifs",
            path: "/search",
            method: .get,
            parameters: [
                "api_key": apiKey,
                "q": query,
                "limit": "\(limit)",
                "offset": "\(offset)",
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
