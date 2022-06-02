//
//  LanguageSelectionType.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

enum LanguageSelectionType {
    case source
    case target
    
    
    var navigationTitle: String {
        switch self {
        case .source:
            return "Select Source"
        case .target:
            return "Select Target"
        }
    }
}
