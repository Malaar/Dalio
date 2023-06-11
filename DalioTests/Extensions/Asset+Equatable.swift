//
//  Asset+Equatable.swift
//  DalioTests
//
//  Created by Malaar on 11.06.2023.
//

import Foundation
@testable import Dalio

extension Asset: Equatable {
    public static func == (lhs: Asset, rhs: Asset) -> Bool {
        lhs.capitalization == rhs.capitalization &&
        lhs.info == rhs.info &&
        lhs.symbol == rhs.symbol &&
        lhs.last == rhs.last
    }
}
