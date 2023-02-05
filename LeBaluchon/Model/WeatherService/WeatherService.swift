//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import Foundation


final class WeatherService {
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared,
        weatherUrlProvider: WeatherUrlProviderProtocol = WeatherUrlProvider.shared
    ) {
        self.networkService = networkService
        self.weatherUrlProvider = weatherUrlProvider
    }
    
    
    // MARK: - INTERNAL: properties
    
    static let shared = WeatherService()
    
    var weatherCitiesDidChange: (() -> Void)?
    var isLoadingDidChange: ((Bool) -> Void)?
    var didProduceError: ((WeatherServiceError) -> Void)?
    var onSearchResultChanged: (() -> Void)?
    var onSearchTextChanged: ((String) -> Void)?
    
    var isLoading: Bool {
        currentDownloadCount != 0
    }
    
    var selectedCities: [WeatherCitySelection] = [
        .newYork
    ] {
        didSet {
            weatherCitiesDidChange?()
            fetchCitiesInformation()
        }
    }
    
    var weatherCities: [WeatherCitySelection : WeatherCity] = [:] {
        didSet {
            weatherCitiesDidChange?()
        }
    }
    
    var searchText = "" {
        didSet {
            onSearchTextChanged?(searchText)
            filteredCities = getFilteredCities(searchText: searchText)
        }
    }
    
    
    lazy var filteredCities: [WeatherCitySelection] = cities {
        didSet {
            onSearchResultChanged?()
        }
    }
    
    
    // MARK: - INTERNAL: methods
    
    func add(city: WeatherCitySelection) {
        guard !selectedCities.contains(city) else {
            didProduceError?(.failedToAddNewCityAlreadyThere)
            return
        }
        
        selectedCities.append(city)
    }
    
    func removeCity(cityIndex: Int) {
        let cityToRemove = selectedCities[cityIndex]
        remove(city: cityToRemove)
    }
    
    func remove(city: WeatherCitySelection) {
        weatherCities[city] = nil
        selectedCities.removeAll { citySelection in
            citySelection == city
        }
    }
    
    func emptySearchText() {
        searchText.removeAll()
    }
    
    func fetchCitiesInformation() {
        for selectedCity in selectedCities {
            currentDownloadCount += 1
            fetch(citySelection: selectedCity) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.didProduceError?(error)
                case .success(let weatherCity):
                    self?.weatherCities[selectedCity] = weatherCity
                }
                self?.currentDownloadCount -= 1
            }
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private var currentDownloadCount = 0 {
        didSet {
            isLoadingDidChange?(isLoading)
        }
    }
    
    private let cities: [WeatherCitySelection] = WeatherCitySelection.allCases
    
    private let networkService: NetworkServiceProtocol
    private let weatherUrlProvider: WeatherUrlProviderProtocol
    
    
    // MARK: - PRIVATE: methods
    
    private func fetch(citySelection: WeatherCitySelection, completionHandler: @escaping (Result<WeatherCity, WeatherServiceError>) -> Void) {
        guard let url = weatherUrlProvider.getWeatherUrl(city: citySelection.title) else {
            completionHandler(.failure(.failedToFetchCityWeather))
            return
        }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "GET"
        
        networkService.fetch(urlRequest: urlRequest) { (result: Result<WeatherCityResponse, NetworkServiceError>) in
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchCityWeather))
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
                    description: weatherDescription,
                    temperatureMax: Int(temperatureMax),
                    temparatureMin: Int(temperatureMin),
                    temperatureCurrent: Int(temperature),
                    weatherIconImage: weatherIcon
                )
                
                completionHandler(.success(weatherCity))
                return
            }
        }
    }
    
    private func getFilteredCities(searchText: String) -> [WeatherCitySelection] {
        guard !searchText.isEmpty else {
            return cities
        }
        
        return cities.filter { city in
            city.title.lowercased().contains(searchText.lowercased())
        }
    }
}

protocol WeatherUrlProviderProtocol {
    func getWeatherUrl(city: String) -> URL?
}

final class WeatherUrlProvider: WeatherUrlProviderProtocol {
    static let shared = WeatherUrlProvider()
    
    func getWeatherUrl(city: String) -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            .init(name: "q", value: city),
            .init(name: "lang", value: "fr"),
            .init(name: "units", value: "metric"),
            .init(name: "appid", value: APIKeys.weatherKey)
        ]
        
        return urlComponents.url
    }
}
