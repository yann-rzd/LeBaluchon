//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import Foundation

final class WeatherService {
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared
    ) {
        self.networkService = networkService
    }
    
    
    // MARK: - INTERNAL: properties
    
    static let shared = WeatherService()
    
    var weatherCitiesDidChange: (() -> Void)?
    
    var selectedCities: [WeatherCitySelection] = [
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
                }
            }
           
        }
    }
    
    var weatherCities: [WeatherCitySelection : WeatherCity] = [:
//        .newyork : .init(title: "New-York", description: "Bell eclaircies", temperatureMax: 21, temparatureMin: 10, temperatureCurrent: 19),
//        .paris : .init(title: "Paris", description: "Nuages", temperatureMax: 19, temparatureMin: 8, temperatureCurrent: 17)
    ] {
        didSet {
            weatherCitiesDidChange?()
            // notifiy viewcontroller that the weather cities changed => tableview reload data
        }
    }
    
    
    // MARK: - INTERNAL: methods
    
    func add(city: WeatherCitySelection) {
        selectedCities.append(city)
    }
    
    func remove(city: WeatherCitySelection) {
        weatherCities[city] = nil
        selectedCities.removeAll { citySelection in
            citySelection == city
        }
    }
    
    
    // MARK: - PRIVATE: properties
    private let networkService: NetworkServiceProtocol
    
    private let apiKey = "fdec102a8f3538aeca01f9b15b1c58a7"
    
    
    // MARK: - PRIVATE: methods
    
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
    
    private func fetch(citySelection: WeatherCitySelection, completionHandler: @escaping (Result<WeatherCity, WeatherServiceError>) -> Void) {
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
                    temperatureCurrent: Int(temperature),
                    weatherIconImage: weatherIcon ?? nil
                )
                
                completionHandler(.success(weatherCity))
                return

            }
        }
    }
}
