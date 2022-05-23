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
        default:
            return "Unknown"
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
        .newyork,
        .paris
    ] {
        didSet {
            fetch { result in
//                switch result {
//                case .success():
//                }
            }
        }
    }
    
    
    var weatherCities: [CitySelection : WeatherCity] = [:
//        .newyork : .init(title: "New-York", description: "Bell eclaircies", temperatureMax: 21, temparatureMin: 10, temperatureCurrent: 19),
//        .paris : .init(title: "Paris", description: "Nuages", temperatureMax: 19, temparatureMin: 8, temperatureCurrent: 17)
    ] {
        didSet {
            // notifiy viewcontroller that the weather cities changed => tableview reload data
        }
    }
    
    
    
    
    func fetch(completionHandler: @escaping (Result<Void, WeatherServiceError>) -> Void) {
        guard let url = getRatesUrl() else {
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
                let weatherDescription = weatherCityResponse.weather[2]
                let temperatureMax = weatherCityResponse.main.tempMax
                let temperatureMin = weatherCityResponse.main.tempMin
                let temperature = weatherCityResponse.main.temp
                let weatherIcon = weatherCityResponse.weather[3]
                completionHandler(.success(()))
                return

            }
        }
    }
    
    private let networkService: NetworkServiceProtocol
    
    private let apiKey = "fdec102a8f3538aeca01f9b15b1c58a7"
    
    private func getRatesUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            .init(name: "access_key", value: apiKey)
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
