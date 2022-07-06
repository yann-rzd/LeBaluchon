//
//  CurrencyServiceError.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

enum CurrencyServiceError: Error {
    case failedToFetchConversionRate
    
    var alertTitle: String {
        switch self {
        case .failedToFetchConversionRate:
            return "Error"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .failedToFetchConversionRate:
            return  "Failed to fetch rates."
        }
    }
}
