//
//  AssetView.swift
//  Asset
//
//  Created by Malaar on 10.06.2023.
//

import UIKit
import Reusable

struct AssetViewState {
    let name: String
    let capitalization: String
    let price: String
    let marketStatus: String
    
    static var empty: AssetViewState { AssetViewState(name: "", capitalization: "", price: "", marketStatus: "") }
}

final class AssetView: UIView, NibOwnerLoadable {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var capitalizationLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var marketStatusLabel: UILabel!
    
    // MARK: - State
    
    var state: AssetViewState! {
        didSet { setup(with: state) }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
    
    // MARK: - Configuration
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
    
    private func setup(with state: AssetViewState) {
        nameLabel.text = state.name
        capitalizationLabel.text = state.capitalization
        priceLabel.text = state.price
        marketStatusLabel.text = state.marketStatus
    }
}
