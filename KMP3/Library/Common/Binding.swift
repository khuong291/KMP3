//
//  Binding.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

/// Use for binding data to view
class Binding<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
