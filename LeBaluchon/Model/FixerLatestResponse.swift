//
//  FixerLatestResponse.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 24/03/2022.
//

import Foundation

struct FixerLatestResponse: Decodable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Double]
}
