//
//  AssetRepositoryTests.swift
//  DalioTests
//
//  Created by Malaar on 11.06.2023.
//

import XCTest
import RxSwift
@testable import Dalio

final class AssetRepositoryTests: XCTestCase {
    
    // MARK: - Mocks
    
    private var assetNetworkService: AssetNetworkServiceMock!
    private var assetStorageService: AssetStorageMock!
    private var assetRepository: AssetRepositoryType!
    
    // MARK: - State
    
    private var disposeBag: DisposeBag!
    
    // MARK: - Configuration
    
    override func setUpWithError() throws {
        assetNetworkService = AssetNetworkServiceMock()
        assetStorageService = AssetStorageMock()
        assetRepository = AssetRepository(assetNetworkService: assetNetworkService, assetStorage: assetStorageService)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        assetNetworkService = nil
        assetStorageService = nil
        assetRepository = nil
        disposeBag = nil
    }
    
    // MARK: - Tests
    
    func testFetchAndMapRemoteAssetCorrectly() throws {
        var response: Asset?
        
        // MARK: Given
        assetStorageService.storedAsset = nil
        assetNetworkService.responseSuccessful(Self.remoteAsset)
        
        // MARK: When
        let expectation = expectation(description: "fetchRemoteAsset")
        assetRepository.asset()
            .subscribe(
                onNext: { asset in
                    response = asset
                    expectation.fulfill()
                },
                onError: { _ in
                    expectation.fulfill()
                })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
        
        // MARK: Then
        XCTAssertEqual(response, Self.remoteToLocal(Self.remoteAsset), "Received asset should be correct")
    }
    
    func testFetchedAsetShouldBeStored() {
        var cachedAsset: Asset?
        
        // MARK: Given
        assetStorageService.storedAsset = nil
        assetNetworkService.responseSuccessful(Self.remoteAsset)
        
        // MARK: When
        let remoteExpectation = expectation(description: "fetchRemoteAsset")
        assetRepository.asset()
            .subscribe(
                onNext: { _ in remoteExpectation.fulfill() },
                onError: { _ in remoteExpectation.fulfill() })
            .disposed(by: disposeBag)
        
        wait(for: [remoteExpectation], timeout: 1.0)
        
        let localExpectation = expectation(description: "fetchLocalAsset")
        assetStorageService.asset()
            .subscribe(
                onSuccess: { asset in
                    cachedAsset = asset
                    localExpectation.fulfill()
                },
                onFailure: { _ in
                    localExpectation.fulfill()
                })
            .disposed(by: disposeBag)
        wait(for: [localExpectation], timeout: 1.0)
        
        // MARK: Then
        XCTAssertEqual(cachedAsset, Self.remoteToLocal(Self.remoteAsset), "Cached asset should be equal to remote")
    }
    
    func testFetchCachedAssetFirstly() {
        var response: Asset?
        
        // MARK: Given
        assetStorageService.storedAsset = Self.localAsset
        assetNetworkService.responseFailed(.noData)
        
        // MARK: When
        let expectation = expectation(description: "fetchRemoteAsset")
        assetRepository.asset()
            .take(1)
            .subscribe(
                onNext: { asset in
                    response = asset
                    expectation.fulfill()
                },
                onError: { _ in
                    expectation.fulfill()
                })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1.0)
        
        // MARK: Then
        XCTAssertEqual(response, Self.localAsset, "Cached asset should be fetched")
    }
}

// MARK: - Stabs

private extension AssetRepositoryTests {
    static var remoteAsset: Network.Asset { Network.Asset(symbol: "AAPL", last: 123, marketCap: 99999, info: "Open") }
    static var localAsset: Asset { Asset(symbol: "AAPL", last: 1233, capitalization: 989898, info: "Closed") }
    
    static func remoteToLocal(_ remoteAsset: Network.Asset) -> Asset {
        Asset(symbol: remoteAsset.symbol, last: remoteAsset.last, capitalization: remoteAsset.marketCap, info: remoteAsset.info)
    }
}
