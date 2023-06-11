//
//  StreamHandler.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import RxSwift
import RxCocoa

/// Helps to solve routine around handling completable streams
///  Separate completable income stream into 2 infinite streams:
///  + **error** - indicate is error occurred (triggered when received error in stream )
///  + **response** - stream with only successful responses
///
final class StreamHandler<Item> {
    
    typealias Stream = Observable<Item>
    
    // MARK: - Output streams
    
    let error: Signal<Error>
    let response: Signal<Item>
    
    // MARK: - Input stream
    
    private let streamTriger = PublishSubject<Stream>()
    
    // MARK: - Initialization
    
    init() {
        let stream = streamTriger
            .flatMapLatest { $0 }
            .materialize()
            .share()
        
        error = stream
            .compactMap { $0.event.error }
            .asSignal(onErrorSignalWith: .never())
        
        response = stream
            .compactMap { $0.event.element }
            .asSignal(onErrorSignalWith: .never())
    }
    
    // MARK: - Input
    
    func handle(_ stream: Stream) {
        streamTriger.onNext(stream)
    }
    
    func asObserver() -> AnyObserver<Stream> {
        streamTriger.asObserver()
    }
}
