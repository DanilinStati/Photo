//
//  NetworkDataFetcher.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 15.02.2021.
//

import Foundation

class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decoded = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decoded)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let data = from else { return nil }
        do {
            let obj = try decoder.decode(type.self, from: data)
            return obj
        } catch let jsonError{
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
