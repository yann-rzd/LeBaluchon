//
//  CurrencyServiceError.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

enum CurrencyServiceError: LocalizedError {
    case failedToFetchConversionRate
    
    
    var errorDescription: String {
        switch self {
        case .failedToFetchConversionRate:
            return  "Failed to fetch rates."
        }
    }
}
