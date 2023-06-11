//
//  Asset.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation

enum Network {}

extension Network {
    struct Asset: Decodable {
        let symbol: String
        let close: Float
        let marketCap: Double
        let info: String
    }
    
    struct AssetResponse: Decodable {
        let realTimeQuotes: [Asset]
    }
}

