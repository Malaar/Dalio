//
//  AssetDAO.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import RxSwift

protocol AssetStorageType {
    func asset() -> Single<Asset?>
    func save(_ asset: Asset?)
}

final class AssetStorage: AssetStorageType {
    
    private static let assetKey = "asset"
    
    func asset() -> Single<Asset?> {
        guard let data = UserDefaults.standard.object(forKey: Self.assetKey) as? Data else {
            return .just(nil)
        }
        
        let decoder = JSONDecoder()
        let asset = try? decoder.decode(Asset.self, from: data)
        return .just(asset)
    }
    
    func save(_ asset: Asset?) {
        guard let asset = asset else {
            UserDefaults.standard.removeObject(forKey: Self.assetKey)
            return
        }
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(asset) {
            UserDefaults.standard.set(data, forKey: Self.assetKey)
        }
    }
}
