//
//  ApiCaller.swift
//  News
//
//  Created by Elmar Ibrahimli on 28.05.23.
//

import Foundation

final class ApiCaller {
    static let shared = ApiCaller()
    private init() {}
    
    struct Constants{
        static let baseUrl: String = "https://newsdata.io/api/1/news?apikey=pub_23561009608b5d299ae9fb303b94c261a755b&language=en,tr,az,ru"
    }
    
    struct ApiError: LocalizedError {
        let description: String

        init(_ description: String) {
            self.description = description
        }

        var errorDescription: String? {
            description
        }
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    public func getNews(nextPage: String?, completion: @escaping (Result<NewsResponse, Error>) -> Void) {
        let url = nextPage == nil ? Constants.baseUrl : Constants.baseUrl + "&page=\(nextPage ?? "")"
        print(url)
        createRequest(url: URL(string: url), method: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError("failedToGetData")))
                    return
                }
                do {
                    let jsonString = try JSONSerialization.jsonObject(with: data)
                    if let dictionary = jsonString as? [String: Any],
                       dictionary["status"] as? String == "error",
                       let results = dictionary["results"] as? [String: Any],
                       let message = results["message"] as? String
                    {
                        completion(.failure(ApiError(message)))
                        return
                    }
                    var result = try JSONDecoder().decode(NewsResponse.self, from: data)
                    result.results = result.results.filter({ item in
                        item.image_url != nil
                    })
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
                
            }.resume()
        }
    }
    
    private func createRequest(url: URL?, method: HTTPMethod, completion: @escaping(URLRequest) -> Void) {
        guard let url = url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        completion(request)
    }
}
