//
//  AssetNetworkServiceMock.swift
//  DalioTests
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import RxSwift
@testable import Dalio

final class AssetNetworkServiceMock: AssetNetworkServiceType {
    
    private var response: Network.Asset?
    private var error: NetworkError?
    
    func responseSuccessful(_ asset: Network.Asset) {
        response = asset
        error = nil
    }
    
    func responseFailed(_ error: NetworkError) {
        self.error = error
        response = nil
    }
    
    func asset() -> Single<Network.Asset> {
        guard let response = response else {
            return .error(error ?? .noData)
        }
        return .just(response)
    }
}
