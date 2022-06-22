//
//  City.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

enum WeatherCitySelection: CaseIterable {
    case paris, newyork, copenhague, london
    
    var isDeletable: Bool {
        switch self {
        case .newyork:
            return false
        default:
            return true
        }
    }
    
    var title: String {
        switch self {
        case .newyork:
            return "New York"
        case .paris:
            return "Paris"
        case .copenhague:
            return "Copenhague"
        case .london:
            return "Londres"
        }
    }
}
