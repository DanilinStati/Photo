//
//  NetworkService.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 15.02.2021.
//

import Foundation

class NetworkService {
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        let parametrs = self.prepareParametrs(searchTerm: searchTerm)
        let url = self.url(parametrs: parametrs)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func url(parametrs: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = parametrs.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func prepareParametrs(searchTerm: String?) -> [String: String] {
        var parametrs = [String: String]()
        parametrs["query"] = searchTerm
        parametrs["page"] = String(randomPage())
        parametrs["per_page"] = String(100)
        return parametrs
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID moiVxY1EF0tJ9euRVH1EmIEgMwqAAEEgS9vZyEfYl0M"
        return headers
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, responce, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    private func randomPage() -> Int {
        let page = 1...100
        let pageInURL = page.randomElement() ?? 1
        return pageInURL
    }
}
