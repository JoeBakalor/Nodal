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
    var numberInputs: Int { get }
    var numberOutputs: Int { get }
}
