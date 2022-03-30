//
//  CurencyServiceProtocol.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 24/03/2022.
//

import Foundation

protocol CurencyServiceProtocol {
    func fetchConversionRates(completionHandler: @escaping (Result<[String: Double], CurrencyServiceError>) -> Void)
}
