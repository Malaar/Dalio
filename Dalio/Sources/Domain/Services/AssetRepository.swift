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
            .map { Asset(symbol: $0.symbol, last: $0.last, capitalization: $0.marketCap, info: $0.info) }
            .do { [assetStorage] asset in
                assetStorage.save(asset)
            }
            .asObservable()
        
        let localAssetStream = assetStorage.asset()
            .compactMap { $0 }
            .asObservable()
        
        return .concat(localAssetStream, remoteAssetStream)
    }
    
    func save(_ asset: Asset?) {
        assetStorage.save(asset)
    }
}
