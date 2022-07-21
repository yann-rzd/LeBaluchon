//
//  WeatherServiceError.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

enum WeatherServiceError: LocalizedError {
    case failedToFetchCityWeather
    case failedToAddNewCityAlreadyThere
    
    
    
    
    var errorDescription: String {
        switch self {
        case .failedToFetchCityWeather:
            return  "Failed to fetch city information."
        case .failedToAddNewCityAlreadyThere:
            return "Failed to add city to selection as it is already present."
        }
    }
    
}
