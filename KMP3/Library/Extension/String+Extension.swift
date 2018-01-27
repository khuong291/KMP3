//
//  String+Extension.swift
//  KMP3
//
//  Created by KhuongPham on 1/28/18.
//

import Foundation

extension String {
    func toBase64() -> String {
        return Data(utf8).base64EncodedString()
    }
}
