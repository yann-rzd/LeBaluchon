//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import Foundation

enum WeatherServiceError: Error {
    case failedToFetchCityWeather
}

enum CitySelection: CaseIterable {
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
            return "New-York"
        case .paris:
            return "Paris"
        case .copenhague:
            return "Copenhague"
        case .london:
            return "London"
        }
    }
}

final class WeatherService {
    
    static let shared = WeatherService()
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.networkService = networkService
    }
    
//
//    var foreignerCity: WeatherCity {
//        weatherCities[0]
//    }
//
//    var localCity: WeatherCity {
//        weatherCities[1]
//    }
    
    
    
    
    var selectedCities: [CitySelection] = [
    ] {
        didSet {
            weatherCitiesDidChange?()
            for selectedCity in selectedCities {
                fetch(citySelection: selectedCity) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        print("An error occured should display an alert")
                    case .success(let weatherCity):
                        self?.weatherCities[selectedCity] = weatherCity
                        
    
                    }
    //                switch result {
    //                case .success():
    //                }
                }
            }
           
        }
    }
    
    
    var weatherCities: [CitySelection : WeatherCity] = [:
//        .newyork : .init(title: "New-York", description: "Bell eclaircies", temperatureMax: 21, temparatureMin: 10, temperatureCurrent: 19),
//        .paris : .init(title: "Paris", description: "Nuages", temperatureMax: 19, temparatureMin: 8, temperatureCurrent: 17)
    ] {
        didSet {
            weatherCitiesDidChange?()
            // notifiy viewcontroller that the weather cities changed => tableview reload data
        }
    }
    
    
    var weatherCitiesDidChange: (() -> Void)?
    
    
    
    func add(city: CitySelection) {
        selectedCities.append(city)
    }
    
    
    func remove(city: CitySelection) {
        weatherCities[city] = nil
        selectedCities.removeAll { citySelection in
            citySelection == city
        }
        
    }
    
    
    private func fetch(citySelection: CitySelection, completionHandler: @escaping (Result<WeatherCity, WeatherServiceError>) -> Void) {
        guard let url = getWeatherUrl(city: citySelection.title) else {
            return
        }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "GET"

        networkService.fetch(urlRequest: urlRequest) { [weak self] (result: Result<WeatherCityResponse, NetworkServiceError>) in
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchCityWeather))
                print("Erreur lors de la récupération de la météo")
                return
            case .success(let weatherCityResponse):
                let cityName = weatherCityResponse.name
                let weatherDescription = weatherCityResponse.weather.first?.description
                let temperatureMax = weatherCityResponse.main.tempMax
                let temperatureMin = weatherCityResponse.main.tempMin
                let temperature = weatherCityResponse.main.temp
                let weatherIcon = weatherCityResponse.weather.first?.icon
                
            
                
                let weatherCity = WeatherCity(
                    title: cityName,
                    description: weatherDescription!,
                    temperatureMax: Int(temperatureMax),
                    temparatureMin: Int(temperatureMin),
                    temperatureCurrent: Int(temperature)
                )
                
                completionHandler(.success(weatherCity))
                return

            }
        }
    }
    
    private let networkService: NetworkServiceProtocol
    
    private let apiKey = "fdec102a8f3538aeca01f9b15b1c58a7"
    
    private func getWeatherUrl(city: String) -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            .init(name: "q", value: city),
            .init(name: "appid", value: apiKey)
        ]
        
        return urlComponents.url
    }
    
    
}



struct WeatherCity {
    let title: String
    let description: String
    let temperatureMax: Int
    let temparatureMin: Int
    let temperatureCurrent: Int
}
