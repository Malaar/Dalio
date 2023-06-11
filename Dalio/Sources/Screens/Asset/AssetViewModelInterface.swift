//
//  AssetViewModelInterface.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import RxSwift
import RxCocoa

struct AssetViewModelInput {
    let onAppear: AnyObserver<Void>
    let onReload: AnyObserver<Void>
}

struct AssetViewModelOutput {
    let asset: Signal<AssetViewState>
    let error: Signal<String>
}


protocol AssetViewModelType {
    var input: AssetViewModelInput { get }
    var output: AssetViewModelOutput { get }
}
