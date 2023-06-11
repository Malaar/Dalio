//
//  AssetViewController.swift
//  Asset
//
//  Created by Malaar on 10.06.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class AssetViewController: UIViewController {
    
    // MARK: - Outlets & subviews
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var assetView: AssetView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    // MARK: - State
    
    // TODO: In real project instantiate it via DI
    private let viewModel: AssetViewModelType = AssetViewModel(assetRepository: AssetRepository(assetNetworkService: AssetNetworkService(),
                                                                                                assetStorage: AssetStorage()))
    private let disposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupBindings()
        viewModel.input.onAppear.onNext(())
    }
}

// MARK: - Configuration

private extension AssetViewController {
    func setup() {
        scrollView.addSubview(refreshControl)
        scrollView.alwaysBounceVertical = true
        assetView.state = .empty
    }
    
    func setupBindings() {
        viewModel.output.error
            .emit { [weak self] message in
                self?.showAlert(with: message)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.asset
            .emit { [weak assetView, weak refreshControl] state in
                assetView?.state = state
                refreshControl?.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.onReload)
            .disposed(by: disposeBag)
    }
}

// MARK: - Alert

private extension AssetViewController {
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
