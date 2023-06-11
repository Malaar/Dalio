//
//  Asset.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation

struct Asset: Codable {
    let symbol: String
    let close: Float
    let capitalization: Double
    let info: String
}
