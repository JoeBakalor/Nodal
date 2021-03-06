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
    func process(state: NodeState)
    func setDefaults(state: NodeState)
    func compile(state: NodeState) -> String
    static var numberInputs: Int { get }
    static var numberOutputs: Int { get }
    static var operation: Operation { get }
    init()
}
