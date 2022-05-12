//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import Foundation


final class WeatherService {
    
    
    var foreignerCity: WeatherCity {
        weatherCities[0]
    }
    
    var localCity: WeatherCity {
        weatherCities[1]
    }
    
    
    
    private var weatherCities: [WeatherCity] = [
        .init(title: "New-York", description: "Bell eclaircies", temperatureMax: 21, temparatureMin: 10, temperatureCurrent: 19),
        .init(title: "Paris", description: "Nuages", temperatureMax: 19, temparatureMin: 8, temperatureCurrent: 17)
    ]
    
    
    
    
    func fetch() {
        
    }
    
    
}



struct WeatherCity {
    let title: String
    let description: String
    let temperatureMax: Int
    let temparatureMin: Int
    let temperatureCurrent: Int
}
