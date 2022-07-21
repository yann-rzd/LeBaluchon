//
//  TranslateServiceError.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

enum TranslateServiceError: LocalizedError {
    case failedToFetchTranslation
    
    
    var errorDescription: String? {
        switch self {
        case .failedToFetchTranslation:
            return "Failed to translate"
        }
    }
}
