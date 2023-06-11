//
//  AssetStorageMock.swift
//  DalioTests
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import RxSwift
@testable import Dalio

final class AssetStorageMock: AssetStorageType {
    
    var storedAsset: Asset?
    
    func asset() -> Single<Asset?> {
        .just(storedAsset)
    }
    
    func save(_ asset: Asset?) {
        storedAsset = asset
    }
}
