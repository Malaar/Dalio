//
//  AssetRepository.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import RxSwift

protocol AssetRepositoryType {
    func asset() -> Observable<Asset>
    func save(_ asset: Asset?)
}

final class AssetRepository: AssetRepositoryType {
    
    private let assetNetworkService: AssetNetworkServiceType
    private let assetStorage: AssetStorageType
    
    init(assetNetworkService: AssetNetworkServiceType, assetStorage: AssetStorageType) {
        self.assetNetworkService = assetNetworkService
        self.assetStorage = assetStorage
    }
    
    func asset() -> Observable<Asset> {
        let remoteAssetStream = assetNetworkService.asset()
            .asObservable()
            .map { Asset(symbol: $0.symbol, close: $0.close, capitalization: $0.marketCap, info: $0.info) }
            .do { [assetStorage] asset in
                assetStorage.save(asset)
            }
        
        let localAssetStream = assetStorage.asset()
            .asObservable()
            .compactMap { $0 }
        
        return localAssetStream
            .concat(remoteAssetStream)
    }
    
    func save(_ asset: Asset?) {
        assetStorage.save(asset)
    }
}
