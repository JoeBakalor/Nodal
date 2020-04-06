//
//  File.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation

open class NodeTerminal<T> {
    
    @Published public var value: T?
    
    public var index: Int
    
    public init(index: Int) {
        self.index = index
    }
    
}
