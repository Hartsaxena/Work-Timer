//
//  APIResponse.swift
//  WorkTimer
//
//  Created by James Sun on 2/27/23.
//

import Foundation

struct APIResponse: Codable {
    var a: String
    var q: String
}

class QuoteAPIService {
    static func getQuotes() async -> [APIResponse] {
        let urlString = "https://zenquotes.io/api/quotes"
        let requester = URLRequestBuilder(urlString: urlString)
        let request = requester.getURLRequest()
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = APIResponseDecoder(data: data)
            return decoder.decodeAPIResponse()
        } catch {
            print(error)
        }
        
        return []
    }
}


class URLRequestBuilder {
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func getURLRequest() -> URLRequest {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        return request
    }
}


class APIResponseDecoder {
    private let decoder = JSONDecoder()
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func decodeAPIResponse() -> [APIResponse] {
        do {
            let decoderResponse = try decoder.decode([APIResponse].self, from: data)
            return decoderResponse
        } catch {
            print(error)
        }
        
        return []
    }
}
