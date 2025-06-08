//
//  File.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/8/25.
//

import Foundation

public func base64Decoded(_ string: String) -> String? {
    guard let data = Data(base64Encoded: string) else {
        return nil
    }
    
    return String(data: data, encoding: .utf8)
}
