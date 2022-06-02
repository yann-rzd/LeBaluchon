//
//  NetworkServvice.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 24/03/2022.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    
    private let urlSession: URLSession
    
    
    func fetch<T: Decodable>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) {
        
       
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(.failedToFetch))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode
            else {
                completionHandler(.failure(.failedToFetch))
                return
            }
            
            
            guard let data = data else {
                completionHandler(.failure(.failedToFetch))
                return
            }
            
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                completionHandler(.success(decodedData))
            } catch {
                print(error.localizedDescription)
                print(error)
                completionHandler(.failure(.failedToFetch))
            }


        }
        
        task.resume()
    }
    
    
    static let shared = NetworkService()
    
}
