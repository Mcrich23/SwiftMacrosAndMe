//
//  KeychainSwift+Extensions.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/8/25.
//

@preconcurrency import KeychainSwift

public extension KeychainSwift {
    static let shared = KeychainSwift()
}
