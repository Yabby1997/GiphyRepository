//
//  File.swift
//  
//
//  Created by USER on 2023/06/06.
//

import Foundation

struct GiphySearchResultDTO: Decodable {
    let data: [GiphyEntityDTO]
}

struct GiphyEntityDTO: Decodable {
    let id: String
    let title: String
    let source: String
    let images: GiphyImagesDTO
}

struct GiphyImagesDTO: Decodable {
    let original: URL?
    let thumbnail: URL?

    enum CodingKeys: String, CodingKey {
        case original = "original"
        case thumbnail = "downsized"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let originalUrl = try container.decode(GiphyURLDTO.self, forKey: .original)
        let thumbnailUrl = try container.decode(GiphyURLDTO.self, forKey: .thumbnail)
        self.original = originalUrl.url
        self.thumbnail = thumbnailUrl.url
    }
}

struct GiphyURLDTO: Decodable {
    let url: URL?

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringUrl = try container.decode(String.self, forKey: .url)
        self.url = URL(string: stringUrl)
    }
}
