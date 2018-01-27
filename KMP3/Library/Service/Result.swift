//
//  Result.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}
