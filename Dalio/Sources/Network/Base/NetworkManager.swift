//
//  NetworkManager.swift
//  Dalio
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

// TODO: In real project implement here: validation, interception to update access token, error tracking, etc
//
final class NetworkManager {
    private lazy var session = Alamofire.Session()
    
    func get<Model: Decodable>(_ url: URL) -> Single<Model> {
        return session.rx.request(.get, url)
            .responseData()
            .flatMap { response, data -> Single<Model> in
                do {
                    let model: Model = try Self.processData(data)
                    return .just(model)
                } catch {
                    return .error(NetworkError.undecodableResponse)
                }
            }
            .asSingle()
    }
    
    private static func processData<Model: Decodable>(_ data: Data) throws -> Model {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Model.self, from: data)
    }
}
