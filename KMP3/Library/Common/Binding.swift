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
            listeners.forEach {
                $0?(value)
            }
        }
    }
    
    /// Use array for multiple binding in multiple view
    private var listeners: [((T) -> Void)?] = []
    
    init(value: T) {
        self.value = value
    }
    
    /// Use for callback data when value is set
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listeners.append(closure)
    }
    
    /// Remove last closure to avoid memory leak
    func remove() {
        listeners.removeLast()
    }
}
