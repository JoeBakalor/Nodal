//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation

class NodeTerminal<T> {
    
    @Published var value: T?
    
    var index: Int
    
    init(index: Int) {
        self.index = index
    }
    
}
