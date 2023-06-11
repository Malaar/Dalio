//
//  AssetViewModel.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import RxSwift
import RxCocoa
import KMBFormatter

final class AssetViewModel: AssetViewModelType {
    
    // MARK: - Input & Output
    
    private(set) lazy var input = makeInput()
    private(set) lazy var output = makeOutput()
    
    // MARK: - Dependencies
    
    private let assetRepository: AssetRepositoryType
    
    // MARK: - State
    
    private let assetHandler = StreamHandler<Asset>()
    
    // MARK: - Initialization
    
    init(assetRepository: AssetRepositoryType) {
        self.assetRepository = assetRepository
    }
}

// MARK: - Input & Output

private extension AssetViewModel {
    func makeInput() -> AssetViewModelInput {
        AssetViewModelInput(
            onAppear: reloadStream(),
            onReload: reloadStream())
    }
    
    func makeOutput() -> AssetViewModelOutput {
        AssetViewModelOutput(
            asset: assetStream(),
            error: errorStream())
    }
}
    
// MARK: - Streams

private extension AssetViewModel {
    func reloadStream() -> AnyObserver<Void> {
        assetHandler
            .asObserver()
            .mapObserver { [assetRepository] in
                assetRepository.asset()
            }
    }
    
    func assetStream() -> Signal<AssetViewState> {
        assetHandler.response
            .map { Self.state(from: $0) }
    }
    
    func errorStream() -> Signal<String> {
        assetHandler.error
            .map { _ in
                // TODO: In real project error objects should be integrated to properly display errors
                "Some error occurred"
            }
    }
}

// MARK: - View State & Formatters

private extension AssetViewModel {
    static func state(from asset: Asset) -> AssetViewState {
        AssetViewState(
            name: asset.symbol,
            capitalization: Self.capitalization(from: asset.capitalization),
            price: Self.price(from: asset.last),
            marketStatus: asset.info)
    }
    
    static func price(from rawPrice: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: rawPrice)) ?? ""
    }
    
    static func capitalization(from rawCapitalization: Double) -> String {
        let formatter = KMBFormatter()
        let capitalization = formatter.string(for: rawCapitalization) ?? ""
        return "Cap: \(capitalization)"
    }
}
