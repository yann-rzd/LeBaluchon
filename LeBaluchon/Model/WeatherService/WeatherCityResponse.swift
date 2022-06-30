//
//  WeatherCityResponse.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 23/05/2022.
//

import Foundation

struct WeatherCityResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
    
    static func initWithDefaultValues() -> Self {
        WeatherCityResponse(
            coord: .init(lon: 10, lat: 50),
            weather: [],
            base: "",
            main: .init(
                temp: 10,
                feelsLike: 1,
                tempMin: 1,
                tempMax: 1,
                pressure: 1,
                humidity: 1
            ),
            visibility: 1,
            wind: .init(speed: 1, deg: 1),
            clouds: .init(all: 1),
            dt: 1,
            sys: .init(
                type: 1,
                id: 1,
                country: "NewYork",
                sunrise: 1,
                sunset: 1
            ),
            timezone: 1,
            id: 1,
            name: "Name",
            cod: 1
        )
    }
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case description
        case icon
    }
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}




