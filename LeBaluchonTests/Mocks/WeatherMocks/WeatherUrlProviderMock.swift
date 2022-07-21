//
//  WeatherUrlProviderMock.swift
//  LeBaluchonTests
//
//  Created by Yann Rouzaud on 28/06/2022.
//

import Foundation
@testable import LeBaluchon

class WeatherUrlProviderMock: WeatherUrlProviderProtocol {
    func getWeatherUrl(city: String) -> URL? {
        return nil
    }
}
