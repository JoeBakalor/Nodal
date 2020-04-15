//
//  NodeOperation.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation


public protocol NodeOperation {
    associatedtype InputType
    associatedtype OutputType
    func process(state: NodeState<InputType, OutputType>)
    static var numberInputs: Int { get }
    static var numberOutputs: Int { get }
    static var operation: Operation { get }
    init()
}
