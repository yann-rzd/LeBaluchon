//
//  City.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 02/06/2022.
//

import Foundation

enum WeatherCitySelection: CaseIterable {
    case newYork
    case paris
    case berlin
    case rome
    case madrid
    case londres
    case dublin
    case lisbonne
    case bruxelles
    case luxembourg
    case amsterdam
    case berne
    case copenhague
    case oslo
    case stockholm
    case helsinki
    case tallinn
    case riga
    case vilnius
    case varsovie
    case prague
    case vaduz
    case vienne
    case bratislava
    case budapest
    case ljubljana
    case monaco
    case saintMarin
    case ankara
    case vatican
    case zagreb
    case sarajevo
    case bucarest
    case belgrade
    case sofia
    case tirana
    case skopje
    case athenes
    case chisinau
    case kiev
    case minsk
    case moscou
    case tbilissi
    case bakou
    case erevan
    case reykjavik
    case podgorica
    case neuchatel
    
    var isDeletable: Bool {
        switch self {
        case .newYork:
            return false
        default:
            return true
        }
    }
    
    var title: String {
        switch self {
        case .newYork:
            return "New York"
        case .paris:
            return "Paris"
        case .berlin:
            return "Berlin"
        case .rome:
            return "Rome"
        case .madrid:
            return "Madrid"
        case .londres:
            return "Londres"
        case .dublin:
            return "Dublin"
        case .lisbonne:
            return "Lisbonne"
        case .bruxelles:
            return "Bruxelles"
        case .luxembourg:
            return "Luxembourg"
        case .amsterdam:
            return "Amsterdam"
        case .berne:
            return "Berne"
        case .copenhague:
            return "Copenhague"
        case .oslo:
            return "Oslo"
        case .stockholm:
            return "Stockholm"
        case .helsinki:
            return "Helsinki"
        case .tallinn:
            return "Tallin"
        case .riga:
            return "Riga"
        case .vilnius:
            return "Vilnius"
        case .varsovie:
            return "Varsovie"
        case .prague:
            return "Prague"
        case .vaduz:
            return "Vaduz"
        case .vienne:
            return "Vienne"
        case .bratislava:
            return "Bratislava"
        case .budapest:
            return "Budapest"
        case .ljubljana:
            return "Ljubljana"
        case .monaco:
            return "Monaco"
        case .saintMarin:
            return "Saint Martin"
        case .ankara:
            return "Ankara"
        case .vatican:
            return "Vatican"
        case .zagreb:
            return "Zagreb"
        case .sarajevo:
            return "Sarajevo"
        case .bucarest:
            return "Bucarest"
        case .belgrade:
            return "Belgrade"
        case .sofia:
            return "Sofia"
        case .tirana:
            return "Tirana"
        case .skopje:
            return "Skopje"
        case .athenes:
            return "Athènes"
        case .chisinau:
            return "Chisinau"
        case .kiev:
            return "Kiev"
        case .minsk:
            return "Minsk"
        case .moscou:
            return "Moscou"
        case .tbilissi:
            return "Tbilissi"
        case .bakou:
            return "Bakou"
        case .erevan:
            return "Erevan"
        case .reykjavik:
            return "Reykjavik"
        case .podgorica:
            return "Podgorica"
        case .neuchatel:
            return "Neuchâtel"
        }
    }
}
