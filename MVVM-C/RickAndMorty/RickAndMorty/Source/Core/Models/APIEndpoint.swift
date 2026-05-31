//
//  APIEndpoint.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 10/04/2026.
//
import Foundation

// MARK: - API Endpoints
enum APIEndpoint {
    case characters(page: Int)
    case nextPage(urlString: String)
    
    private var baseURL: String {
        "https://rickandmortyapi.com/api"
    }
    
    private var url: URL? {
        switch self {
        case .characters(let page):
            let urlString = "\(baseURL)/character?page=\(page)"
            return URL(string: urlString)
            
        case .nextPage(let urlString):
            return URL(string: urlString)
        }
    }
    
    var urlRequest: URLRequest {
        guard let url = url else {
            fatalError("Invalid URL for endpoint: \(self)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}
