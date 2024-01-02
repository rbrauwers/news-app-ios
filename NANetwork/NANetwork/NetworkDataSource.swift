//
//  NetworkDataSource.swift
//  NANetwork
//
//  Created by Rodrigo Brauwers on 24/11/23.
//

import Foundation
import NAModels

public protocol NetworkDataSource {
    func getSources() async throws -> [Source]
    func getArticles() async throws -> [Article]
}

class DefaultNetworkDataSource : NetworkDataSource {

    private let baseUrl = "https://newsapi.org/"
    
    public init() {}
    
    private var newsApiKey: String? {
        get {
            Bundle.naNetwork.object(forInfoDictionaryKey: "NewsApiKey") as? String
        }
    }
    
    public func getSources() async throws -> [Source] {
        let response: SourcesResponse = try await get(urlPath: "v2/top-headlines/sources")
        if response.status.isOk() {
            return response.sources
        } else {
            throw NAErrors.apiUnavailable
        }
    }
    
    public func getArticles() async throws -> [Article] {
        let response: HeadlinesResponse = try await get(urlPath: "v2/top-headlines?country=us")
        if response.status.isOk() {
            return response.articles.filter { $0.author != nil }
        } else {
            throw NAErrors.apiUnavailable
        }
    }
    
    private func get<T : Decodable>(urlPath: String) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(urlPath)") else {
            throw NAErrors.invalidUrl
        }
        
        var request = URLRequest(url: url)
        
        if let key = newsApiKey {
            request.setValue(key, forHTTPHeaderField: "X-Api-Key")
       }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.isSuccess() else {
            throw NAErrors.genericError
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func post<T : Codable>(urlPath: String, body: T) async throws {
        guard let url = URL(string: urlPath) else {
            throw NAErrors.invalidUrl
        }
        
        guard let codableBody = try? JSONEncoder().encode(body) else {
            throw NAErrors.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = codableBody
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
}

public enum NAErrors : Error {
    case apiUnavailable
    case genericError
    case invalidUrl
}

private extension HTTPURLResponse {
    
    func isSuccess() -> Bool {
        return (200...299).contains(statusCode)
    }
    
}

private extension String {
    
    func isOk() -> Bool {
        return caseInsensitiveCompare("ok") == .orderedSame
    }
    
}
