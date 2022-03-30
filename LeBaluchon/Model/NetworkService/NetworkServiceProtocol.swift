//
//  NetworkServiceProtocol.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 24/03/2022.
//

import Foundation


protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void)
}
