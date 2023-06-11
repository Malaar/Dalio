//
//  AssetNetworkService.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import RxSwift

protocol AssetNetworkServiceType {
    func asset() -> Single<Network.Asset>
}

final class AssetNetworkService: AssetNetworkServiceType {
    
    // TODO: In real project it should be configured via DI
    private lazy var manager = NetworkManager()
    
    func asset() -> Single<Network.Asset> {
        let url = URL(string: "https://finance-api.seekingalpha.com/real_time_quotes?sa_ids=146")!
        let response: Single<Network.AssetResponse> = manager.get(url)
        return response
            .flatMap { response -> Single<Network.Asset> in
                guard let asset = response.realTimeQuotes.first else { return .error(NetworkError.noData) }
                return .just(asset)
            }
    }

}

